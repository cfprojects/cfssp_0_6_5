<!--- 
/***********************************************************************

  Copyright (C) 2005  Ryan Guill (ryanguill@gmail.com)

  This file is part of CF Manager for SlideShowPro (CFSSP).

  CFSSP is free software; you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published
  by the Free Software Foundation; either version 2 of the License,
  or (at your option) any later version.

  CFSSP is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
  MA  02111-1307  USA

************************************************************************/
 --->
<!--- 
	This page handles all of the actions of all of the forms
	Concerning albums and images. 
	--->

<cfif IsDefined("form.Action")>
	<cfswitch expression="#Form.Action#">
		<cfcase value="AlbumCreate">
			
			<cfif DirectoryExists(ExpandPath("../gallery/#Form.Title#/"))>
				<cflocation url="albums.cfm?error=Directory Already Exists" />
			</cfif>
				
			<cfdirectory action="create" directory="#ExpandPath('../gallery/#Form.Title#/')#" />
			<cfdirectory action="create" directory="#ExpandPath('../gallery/#Form.Title#/raw/')#" />
			<cfdirectory action="create" directory="#ExpandPath('../gallery/#Form.Title#/lg/')#" />
			<cfdirectory action="create" directory="#ExpandPath('../gallery/#Form.Title#/tn/')#" />
			
			<cfif IsDefined("Form.TN") and Trim(Form.TN) NEQ "">
				<cffile action="upload" destination="#ExpandPath("../gallery/#Form.Title#/")#" filefield="form.tn" nameconflict="makeunique" accept="image/jpeg,image/pjpeg,image/jpg" />
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#Form.Title#/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#Form.Title#/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.AlbumTNWidth#" />
				</cfinvoke>
			<cfelse>
				<cfset File.Serverfile = "" />
			</cfif>
			
			<!--- the following lock is really just a test.  
				I am not great with locks, and not sure that this is the best way to implement them. 
				--->
			<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.SlideShow#" method="AlbumCreate" returnvariable="AlbumCreateRet">
					<cfinvokeargument name="Title" value="#Form.Title#"/>
					<cfinvokeargument name="Description" value="#Form.Description#"/>
					<cfinvokeargument name="lgPath" value="gallery/#Form.Title#/lg/"/>
					<cfinvokeargument name="tnPath" value="gallery/#Form.Title#/tn/"/>
					<cfif File.ServerFile eq "">
						<cfinvokeargument name="tn" value=""/>
					<cfelse>
						<cfinvokeargument name="tn" value="gallery/#Form.Title#/#File.ServerFile#"/>
					</cfif>
					<cfinvokeargument name="AlbumXMLID" value="#Form.AlbumXMLID#" />
				</cfinvoke>
			</cflock>
			
			<cflocation url="albums.cfm?success=Album Successfully Created" />
			
		</cfcase>
		
		<cfcase value="AlbumEdit">
			<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

			<cfif GetAlbumsRet.Done>
				<cfdump var="#GetAlbumsRet#" />
			</cfif>
			
			<!--- Get Previous --->
			<cfset arPrevAlbumInfo = ArrayNew(1) />
			
			<cfset arPrevAlbumInfo[1] = GetAlbumsRet.arAlbums[Form.iAlbum][1] /><!--- title --->
			<cfset arPrevAlbumInfo[2] = GetAlbumsRet.arAlbums[Form.iAlbum][2] /><!--- description --->
			<cfset arPrevAlbumInfo[3] = GetAlbumsRet.arAlbums[Form.iAlbum][3] /><!--- lg dir --->
			<cfset arPrevAlbumInfo[4] = GetAlbumsRet.arAlbums[Form.iAlbum][4] /><!--- tn dir --->
			<cfset arPrevAlbumInfo[5] = GetAlbumsRet.arAlbums[Form.iAlbum][5] /><!--- tn file --->
			<cfset arPrevAlbumInfo[6] = GetAlbumsRet.arAlbums[Form.iAlbum][6] /><!--- pics --->
			<cfset arPrevAlbumInfo[7] = GetAlbumsRet.arAlbums[Form.iAlbum][7] /><!--- index --->
			<cfset arPrevAlbumInfo[8] = GetAlbumsRet.arAlbums[Form.iAlbum][8] /><!--- the album ID --->
			
			<cfset Form.TNNew = arPrevAlbumInfo[5] />
			
			<!--- first thing we need to do is check to see if the title of the album has changed --->
			<!--- if so, then we need to rename the directory, and update the array to the new values --->
			<!--- if not, then skip these steps --->
			<cfif form.Title NEQ arPrevAlbumInfo[1]>
				<!--- first check to see that the previous directory exists --->
				<cfif DirectoryExists(ExpandPath("../gallery/#arPrevAlbumInfo[1]#/"))>
					<!--- if so then rename the directory --->
					<cfdirectory action="rename" directory="#ExpandPath("../gallery/#arPrevAlbumInfo[1]#/")#" newdirectory="#Form.Title#" />
					
					<cfset Variables.TNFilename = GetFileFromPath(ExpandPath(Form.TNNew)) />
					<cfset Form.TNNew = "gallery/#Form.Title#/#Variables.TNFilename#" />
				<cfelse>
					<!--- if not then error out --->
					The old directory did not exist, which means there is problems.
					<cfabort />
				</cfif>
			</cfif>
			
			<!--- now check to see if a new thumnail was uploaded --->
			<cfif IsDefined("Form.TN") and Trim(Form.TN) NEQ "">
				<!--- if so, then we need to remove the old file, and then upload and resize the new one --->
				<cfif FileExists(ExpandPath(arPrevAlbumInfo[5]))>
					<cffile action="delete" file="#ExpandPath(arPrevAlbumInfo[5])#" />
				</cfif>
				
				<cffile action="upload" destination="#ExpandPath("../gallery/#Form.Title#/")#" filefield="form.tn" nameconflict="makeunique" accept="image/jpeg,image/pjpeg,image/jpg" />
				
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#Form.Title#/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#Form.Title#/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.AlbumTNWidth#" />
				</cfinvoke>
				
				<cfset Form.TNNew= "gallery/#Form.Title#/#File.ServerFile#" />
			<cfelse>
				<!--- if not then leave the file the way it was --->
				
			</cfif>
			
			<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.SlideShow#" method="AlbumEdit" returnvariable="AlbumEditRet">
					<cfinvokeargument name="iAlbum" value="#form.iAlbum#"/>
					<cfinvokeargument name="Title" value="#Form.title#"/>
					<cfinvokeargument name="Description" value="#Form.Description#"/>
					<cfinvokeargument name="lgPath" value="gallery/#Form.Title#/lg/"/>
					<cfinvokeargument name="tnPath" value="gallery/#Form.Title#/tn/"/>
					<cfinvokeargument name="tn" value="#Form.TNNew#"/>
					<cfinvokeargument name="AlbumXMLID" value="#Form.AlbumXMLID#" />
				</cfinvoke>
			</cflock>
			
			<cflocation url="albums.cfm?success=Album Successfully Edited" />
		</cfcase>
		
		<cfcase value="AlbumRemove">
			<!--- the following line has been left out because you need cfmx7 to use recurse, 
			and so will not remove the files or directories when you remove an album. --->
			<!--- <cfdirectory action="delete" directory="#ExpandPath('/SlideShow/gallery/#Form.DirectoryName#/')#" recurse="true" /> --->
			
			<cfif Form.DeleteDir>
				<cfinclude template="include/fDeleteDirRecurse.cfm" />
				
				<cfset DeleteDirRecurse(ExpandPath("../gallery/#Form.DirectoryName#/")) />
			</cfif>		
			
			<cfinvoke component="#Application.SlideShow#" method="AlbumRemove" returnvariable="AlbumRemoveRet">
				<cfinvokeargument name="iAlbum" value="#Form.iAlbum#"/>
			</cfinvoke>
			
			<cfif AlbumRemoveRet.Done>
				<cfdump var="#AlbumRemoveRet#" />
			<cfelse>
				<cflocation url="albums.cfm?success=Album Successfully Removed" />
			</cfif>
		</cfcase>
		
		<cfcase value="ImageCreate">
			<cfif IsDefined("Form.src") and Trim(Form.src) NEQ "">
				
				<cffile action="upload" destination="#ExpandPath("../gallery/#Form.FolderName#/raw/")#" filefield="form.src" nameconflict="makeunique" accept="image/jpeg,image/pjpeg,image/jpg" />
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#Form.FolderName#/raw/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#Form.FolderName#/lg/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.ImageFullWidth#" />
				</cfinvoke>
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#Form.FolderName#/raw/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#Form.FolderName#/tn/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.ImageTNWidth#" />
				</cfinvoke>
				
				<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
					<cfinvoke component="#Application.SlideShow#" method="ImageCreate" returnvariable="ImageCreateRet">
						<cfinvokeargument name="iAlbum" value="#Form.iAlbum#"/>
						<cfinvokeargument name="src" value="#File.ServerFile#"/>
						<cfinvokeargument name="caption" value="#Form.Caption#"/>
						<!--- <cfinvokeargument name="link" value="#Form.Link#"/>
						If you want to allow the user to enter a link, replace the line below with the line above --->
						<cfif Form.UseRaw>
							<cfinvokeargument name="link" value="gallery/#Form.FolderName#/Raw/#File.ServerFile#"/>
						<cfelse>
							<cfinvokeargument name="link" value="#Form.Link#"/>
						</cfif>
					</cfinvoke>
				</cflock>
				
				<cflocation url="albumView.cfm?iAlbum=#Form.iAlbum#&success=Image Successfully Added" />
			</cfif>
		</cfcase>
		
		<cfcase value="ImageEdit">
			<!--- <cfdump var="#Form#" />
			<cfabort /> --->
			<!--- load in the array of images in this album --->
			<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

			<cfif GetAlbumsRet.Done>
				<cfdump var="#GetAlbumsRet#" />
			</cfif>
			
			<cfinvoke component="#Application.SlideShow#" method="GetImages" returnvariable="GetImagesRet">
				<cfinvokeargument name="AlbumIndex" value="#form.iAlbum#"/>
			</cfinvoke>
			
			<cfif GetImagesRet.Done>
				<cfdump var="#GetImagesRet#" />
			</cfif>
			
			<!--- first check to see if an image was uploaded.  
				If so, we need to delete the previous image, and then upload and resize the new image --->
			<cfif IsDefined("Form.src") and Trim(Form.src) NEQ "">
				<cfif FileExists(#ExpandPath("../#GetAlbumsRet.arAlbums[form.ialbum][4]##GetImagesRet.arImages[form.iImage][1]#")#)>
					<cffile action="delete" file="#ExpandPath("../#GetAlbumsRet.arAlbums[form.ialbum][4]##GetImagesRet.arImages[form.iImage][1]#")#" />
				</cfif>
				<cfif FileExists(#ExpandPath("../#GetAlbumsRet.arAlbums[form.ialbum][3]##GetImagesRet.arImages[form.iImage][1]#")#)>
					<cffile action="delete" file="#ExpandPath("../#GetAlbumsRet.arAlbums[form.ialbum][3]##GetImagesRet.arImages[form.iImage][1]#")#" />
				</cfif>
				
				<cffile action="upload" destination="#ExpandPath("../gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/raw/")#" filefield="form.src" nameconflict="makeunique" accept="image/jpeg,image/pjpeg,image/jpg" />
				
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/raw/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/lg/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.ImageFullWidth#" />
				</cfinvoke>
				
				<cfinvoke component="cfc.Img" method="resize" returnvariable="resizeRet">
					<cfinvokeargument name="source" value="../gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/raw/#File.ServerFile#"/>
					<cfinvokeargument name="Destination" value="../gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/tn/#File.ServerFile#" />
					<cfinvokeargument name="newWidth" value="#Application.Config.ImageSizes.ImageTNWidth#" />
				</cfinvoke>
				
				<cfset Form.SrcFile = File.ServerFile />
			<cfelse>
				<!--- if not then were just going to change the caption --->
				<cfset Form.SrcFile = GetImagesRet.arImages[form.iImage][1] />
			</cfif>
			
			<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.SlideShow#" method="ImageEdit" returnvariable="ImageEditRet">
					<cfinvokeargument name="iAlbum" value="#Form.iAlbum#"/>
					<cfinvokeargument name="iImage" value="#Form.iImage#"/>
					<cfinvokeargument name="src" value="#Form.SrcFile#"/>
					<cfinvokeargument name="caption" value="#Form.Caption#"/>
					
					<cfif Form.UseRaw>
						<cfif IsDefined("Form.src") and Trim(Form.src) NEQ "">
							<cfinvokeargument name="link" value="gallery/#GetAlbumsRet.arAlbums[form.ialbum][1]#/Raw/#Form.SrcFile#"/>
						<cfelse>
							<cfif GetImagesRet.arImages[form.iImage][2] NEQ "gallery/#GetAlbumsRet.arAlbums[form.iAlbum][1]#/Raw/#GetImagesRet.arImages[form.iImage][1]#">
								<cfinvokeargument name="link" value="gallery/#GetAlbumsRet.arAlbums[Form.iAlbum][1]#/Raw/#Form.SrcFile#"/>
							<cfelse>
								<cfinvokeargument name="link" value="#GetImagesRet.arImages[form.iImage][2]#"/>
							</cfif>
						</cfif>
					<cfelse>
						<cfinvokeargument name="link" value="#Form.Link#"/>
					</cfif>
					
				</cfinvoke>
			</cflock>
			
			<cflocation url="albumView.cfm?iAlbum=#Form.iAlbum#&success=Image Successfully Edited" />
		</cfcase>
		
		<cfcase value="ImageRemove">
			<cffile action="delete" file="#ExpandPath("../gallery/#Form.FolderName#/lg/#Form.ImageName#")#" />
			<cffile action="delete" file="#ExpandPath("../gallery/#Form.FolderName#/tn/#Form.ImageName#")#" />
			
			<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.SlideShow#" method="ImageRemove" returnvariable="ImageRemoveRet">
					<cfinvokeargument name="iAlbum" value="#form.iAlbum#"/>
					<cfinvokeargument name="iImage" value="#Form.iImage#"/>
				</cfinvoke>
			</cflock>
			
			<cflocation url="albumView.cfm?iAlbum=#Form.iAlbum#&success=Image Successfully Removed" />
		</cfcase>
		
		<cfdefaultcase>
			<cflocation url="albums.cfm" />
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cflocation url="albums.cfm" />
</cfif>