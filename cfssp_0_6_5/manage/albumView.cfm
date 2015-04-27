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
<cfif NOT Session.login.UserInRole("ACreate") 
	AND NOT Session.Login.UserInRole("AEdit") 
	AND NOT Session.Login.UserInRole("ARemove") 
	AND NOT Session.Login.UserInRole("IAdd")
	AND NOT Session.Login.UserInRole("IEdit") 
	AND NOT Session.Login.UserInRole("IRemove") 
	AND NOT Session.Login.UserInRole("GlobalAdmin")>
	<cflocation url="insufficientRoles.cfm" />	
</cfif>

<cfif NOT IsDefined("url.iAlbum")>
	<cflocation url="albums.cfm" />
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
			<a href="index.cfm">Home</a> / <a href="albums.cfm">Albums</a> / <a href="albumView.cfm?iAlbum=#url.ialbum#">Album: #GetAlbumsRet.arAlbums[url.ialbum][1]#</a> /
		</div>
		
		<h1>Album: #GetAlbumsRet.arAlbums[url.ialbum][1]#</h1>
		
		<cfif IsDefined("url.error")>
			<h2 style="color:red">#url.Error#</h2>
		</cfif>
		<cfif IsDefined("url.success")>
			<h2 style="color:blue">#url.success#</h2>
		</cfif>
		<h3>Current Images in #GetAlbumsRet.arAlbums[url.ialbum][1]#</h3> 
		<cfif Session.Login.UserInRole("IAdd") OR Session.Login.UserInRole("GlobalAdmin")>
			<p><a href="albumView.cfm?iAlbum=#url.ialbum###EndPage">Jump to End of Page</a></p>
		</cfif>
		<table align="left" width="100%" style="float:top">
			<tr>
				<td>
					<table align="left" style="border-color:##666666; border-width:thin; border-style:groove; margin-bottom:25px;" cellspacing="0" width="100%">
						<cfif GetImagesRet.numImages>
							<cfloop from="1" to="#GetImagesRet.numImages#" index="iImage">
								<cfset Variables.Class = IIF(iImage MOD 2 EQ 0, "''", "'alt'")>
								<tr class="#Variables.class#">
									<td width="75">
										<img width="75" src="../#GetAlbumsRet.arAlbums[url.ialbum][4]##GetImagesRet.arImages[iImage][1]#" border="0" alt="#GetImagesRet.arImages[iImage][3]#" />
									</td>
									<td width="275">
										<cfif GetImagesRet.arImages[iImage][3] EQ "">
											&nbsp;<em>(no caption)</em>
										<cfelse>
											&nbsp;#GetImagesRet.arImages[iImage][3]#
										</cfif>
									</td>
									<td width="50">
										<cfif GetImagesRet.arImages[iImage][2] NEQ "">
											<cfif GetImagesRet.arImages[iImage][2] EQ "Gallery/#GetAlbumsRet.arAlbums[url.iAlbum][1]#/Raw/#GetImagesRet.arImages[iImage][1]#">
												<a href="../#GetImagesRet.arImages[iImage][2]#">Link</a>
											<cfelse>
												<a href="#GetImagesRet.arImages[iImage][2]#">Link</a>
											</cfif>
										<cfelse>
											<em>(no link)</em>
										</cfif>
									</td>
									
										<cfif iImage NEQ 1>
											<form action="imagePos.cfm" method="get">
												<input type="hidden" name="ialbum" value="#url.ialbum#" />
												<input type="hidden" name="iImage" value="#iImage#" />
												<input type="hidden" name="d" value="u" />
												<td width="50">
													<input type="submit" value="Up" />
												</td>
											</form>
										<cfelse>
											<td width="50">
											</td>
										</cfif>
									
										<cfif iImage NEQ GetImagesRet.NumImages>
											<form action="imagePos.cfm" method="get">
												<input type="hidden" name="ialbum" value="#url.ialbum#" />
												<input type="hidden" name="iImage" value="#iImage#" />
												<input type="hidden" name="d" value="d" />
												<td width="50">
													<input type="submit" value="Down" />
												</td>
											</form>
										<cfelse>
											<td width="50">
											</td>
										</cfif>
									
									<cfif Session.Login.UserInRole("IEdit") OR Session.Login.UserInRole("GlobalAdmin")>
										<form action="imageEdit.cfm" method="get">
											<input type="hidden" name="iImage" value="#iImage#" />
											<input type="hidden" name="iAlbum" value="#url.iAlbum#" />
											<td width="50">
												<input type="submit" value="Edit"/>
											</td>
										</form>
									<cfelse>
										<td width="50">
											<button class="disabled">Edit</button>
										</td>
									</cfif>
									<cfif Session.Login.UserInRole("IRemove") OR Session.Login.UserInRole("GlobalAdmin")>
										<form action="albumsAction.cfm" method="post">
											<input type="hidden" name="Action" value="ImageRemove" />
											<input type="hidden" name="iImage" value="#iImage#" />
											<input type="hidden" name="iAlbum" value="#url.iAlbum#" />
											<input type="hidden" name="FolderName" value="#GetAlbumsRet.arAlbums[url.ialbum][1]#" />
											<input type="hidden" name="ImageName" value="#GetImagesRet.arImages[iImage][1]#" />
											<td width="50">
												<input type="submit" value="Remove"/>
											</td>
										</form>
									<cfelse>
										<td width="50">
											<button class="disabled">Remove</button>
										</td>
									</cfif>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td>
									<em>(There are no images in this album yet)</em>
								</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		
		
		<cfif Session.Login.UserInRole("IAdd") OR Session.Login.UserInRole("GlobalAdmin")>
			
			<cfif IsDefined("url.Error")>
				<tr>
					<td>
						<h1 style="color:red">#Url.Error#</h1>
					</td>
				</tr>
			</cfif>
				<cfform action="albumsAction.cfm" method="Post" enctype="multipart/form-data" name="ImageAddForm">
			<tr>
				<td>
					<fieldset>
						<legend>Add Another Image</legend>
						<table align="left" width="100%" style="float:top">
							<tr>
								<td><strong>Caption:</strong></td>
								<td><cfinput type="text" name="Caption" size="55" class="opt" /></td>
							</tr>
							
							<tr>
								<td colspan="2">
									<p>The option below gives you the choice of linking to the fullsize image or to provide a link for the image yourself. You can also choose no and specify a blank link for nothing to happen.</p>
								</td>
							</tr>
							<tr>
								<td>
									<strong>Use Fullsize Image as link?</strong>
								</td>
								<td>
									<input type="radio" name="UseRaw" value="1" id="UseRawYes" checked="checked" /><label for="UseRawYes">Yes</label>
									<input type="radio" name="UseRaw" value="0" id="UseRawNo" /><label for="UseRawNo">No, use the link below</label>
								</td>
							</tr>
							<tr>
								<td>
									<strong>If not, Link:</strong>
								</td>
								<td>
									<cfinput type="text" name="Link" value="" size="55" class="opt" />
								</td>
							</tr>
							 
							<tr>
								<td><strong>Image (.jpg):</strong></div>
								<td><input type="file" value="" size="45" name="src" class="req" /></td>
							</tr>
							
							<input type="hidden" name="Action" value="ImageCreate" />
							<input type="hidden" name="FolderName" value="#GetAlbumsRet.arAlbums[url.ialbum][1]#" />
							<input type="hidden" name="iAlbum" value="#url.iAlbum#" />
							
							<tr>
								<td></td>
								<td><input type="submit" value="Add Image" class="opt" size="20" /></td>
							</tr>
							<tr>
								<td colspan="2">
								<a name="EndPage"></a>
								<br /><br />
									<div class="key">* Form fields this color are required</div>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			</cfform>
		</cfif>
		</table>
	</div>
	</cfoutput>
	
</div>

</body>
</html>