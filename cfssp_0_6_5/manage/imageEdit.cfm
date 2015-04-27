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
 
<cfif NOT Session.Login.UserInRole("IEdit") 
	AND NOT Session.Login.UserInRole("GlobalAdmin")>
	<cflocation url="insufficientRoles.cfm" />	
</cfif>

<cfif NOT IsDefined("url.iAlbum")>
	<cflocation url="albums.cfm" />
</cfif>

<cfif NOT IsDefined("url.iImage")>
	<cflocation url="albumView.cfm?ialbum=#url.ialbum#" />
</cfif>

<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

<cfif GetAlbumsRet.Done>
	<cfdump var="#GetAlbumsRet#" />
</cfif>

<cfinvoke component="#Application.SlideShow#" method="GetImages" returnvariable="GetImagesRet">
	<cfinvokeargument name="AlbumIndex" value="#url.iAlbum#"/>
</cfinvoke>

<cfif GetImagesRet.Done>
	<cfdump var="#GetImagesRet#" />
</cfif>

<cfif GetImagesRet.numImages LT url.iImage>
	<cflocation url="albumView.cfm?ialbum=#url.ialbum#" />
</cfif>

<!--- <cfdump var="#GetImagesRet#" /> --->
<!--- test to see if there is a link, if so then check to see if it is the raw image.  use this information to see what to check in the radio buttons. --->
<cfset Variables.UseRawDefault = 1 />
<cfif GetImagesRet.arImages[url.iImage][2] eq "">
	<cfset Variables.UseRawDefault = 0 />
<cfelse>
	<cfif GetImagesRet.arImages[url.iImage][2] neq "Gallery/#GetAlbumsRet.arAlbums[url.iAlbum][1]#/Raw/#GetImagesRet.arImages[url.iImage][1]#">
		<cfset Variables.UseRawDefault = 0 />
	</cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: Album: <cfoutput>#GetAlbumsRet.arAlbums[url.ialbum][1]#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfinclude template="include/ss.cfm" />
</head>

<body>
		
<cfinclude template="include/header.cfm" />

<div id="container" class="clearfix">

	<cfinclude template="include/nav.cfm" />
	
	<cfoutput>
	<div id="main">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / <a href="albums.cfm">Albums</a> / <a href="albumView.cfm?iAlbum=#url.ialbum#">Album: #GetAlbumsRet.arAlbums[url.ialbum][1]#</a> / <a href="imageEdit.cfm?iAlbum=#url.ialbum#&iImage=#url.iImage#">Edit Image</a> /
		</div>
		
		<h1>Album: #GetAlbumsRet.arAlbums[url.ialbum][1]#: Edit Image</h1>
		
		<cfif IsDefined("url.error")>
			<h2 style="color:red">#url.Error#</h2>
		</cfif>
			
		<table align="left" style="border-color:##666666; border-width:thin; border-style:groove;" width="100%">
			<cfif GetImagesRet.numImages>
				<tr>
					<td align="center">
						<img src="../#GetAlbumsRet.arAlbums[url.ialbum][3]##GetImagesRet.arImages[url.iImage][1]#" border="0" alt="#GetImagesRet.arImages[url.iImage][3]#" />
					</td>
				</tr>
				<tr>
					<td>
						Caption: #GetImagesRet.arImages[url.iImage][3]#
					</td>
				</tr>
				<tr>
					<td>
						Link: 
						<cfif GetImagesRet.arImages[url.iImage][2] NEQ "">
							<cfif Variables.UseRawDefault>
								<a href="../#GetImagesRet.arImages[url.iImage][2]#">#GetImagesRet.arImages[url.iImage][2]#</a>
							<cfelse>
								<a href="#GetImagesRet.arImages[url.iImage][2]#">#GetImagesRet.arImages[url.iImage][2]#</a>
							</cfif>
						<cfelse>
							<em>(no link)</em>
						</cfif>
					</td>								
				</tr>
			<cfelse>
				<tr>
					<td>
						<em>(There are no images in this album yet)</em>
					</td>
				</tr>
			</cfif>
		
				
	
		<cfif Session.Login.UserInRole("IEdit") OR Session.Login.UserInRole("GlobalAdmin")>
			<tr>
				<td>
					<fieldset>
						<legend>Edit This Image</legend>
						<cfform action="albumsAction.cfm" method="Post" enctype="multipart/form-data" name="ImageEditForm">
						
						<table>
							<tr>
								<td><strong>Caption:</strong></td>
								<td><cfinput type="text" name="Caption" size="55" value="#GetImagesRet.arImages[url.iImage][3]#" class="opt" /></td>
							</tr>			
							<tr>
								<td colspan="2">
									<p>The option below gives you the choice of linking to the fullsize image or to provide a link for the image yourself. You can also choose no and specify a blank link for nothing to happen.  If you are uploading a new picture to take the place of this one then you still choose to use the raw image link or one you provide.</p>
								</td>
							</tr>
							
							<tr>
								<td>
									<strong>Use Fullsize Image as link?</strong>
								</td>
								<td>
									<input type="radio" name="UseRaw" value="1" id="UseRawYes" <cfif Variables.UseRawDefault>checked="checked"</cfif> /><label for="UseRawYes">Yes</label>
									<input type="radio" name="UseRaw" value="0" id="UseRawNo" <cfif NOT Variables.UseRawDefault>checked="checked"</cfif>/><label for="UseRawNo">No, use the link below</label>
								</td>
							</tr>
							<tr>
								<td>
									<strong>If not, Link:</strong>
								</td>
								<td>
									<cfinput type="text" name="Link" value="#GetImagesRet.arImages[url.iImage][2]#" size="55" class="opt" />
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<p>You can see this image above. <br />
										If you want to change this image, upload the file using the field below.<br />
										If you do not want to change this image, leave the field below blank.</p>
								</td>
							</tr>
							<tr>
								<td><strong>Image (.jpg):</strong></td>
								<td><input type="file" value="" size="45" name="src" class="opt" /></td>
							</tr>
						
						
						<input type="hidden" name="Action" value="ImageEdit" />
						<input type="hidden" name="iImage" value="#url.iImage#" />
						<input type="hidden" name="iAlbum" value="#url.iAlbum#" />
						
						<tr>
							<td></td>
							<td><input type="submit" value="Edit This Image" class="opt" size="20" /></td>
						</tr>
			
						</cfform>
						<tr>
							<td colspan="2">
								<div class="key">* Form fields this color are required</div>
							</td>
						</tr>
					</fieldset>
				</td>
			</tr>
		</cfif>
		
	</div>
	</cfoutput>
	
</div>

</body>
</html>