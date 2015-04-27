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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: Album Remove: <cfoutput>#GetAlbumsRet.arAlbums[url.ialbum][1]#</cfoutput></title>
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
			<a href="index.cfm">Home</a> / <a href="albums.cfm">Albums</a> / <a href="albumRemove.cfm?iAlbum=#url.ialbum#">Album Remove: #GetAlbumsRet.arAlbums[url.ialbum][1]#</a> /
		</div>
		
		<h1>Remove Album: #GetAlbumsRet.arAlbums[url.ialbum][1]#</h1>
		
		<table align="left" width="100%" style="float:top">
			<tr>
				<td colspan="3">
					Are you sure you want to remove this album?
				</td>
			</tr>
			<tr class="alt">
				<td align="right" valign="center" width="50">
					<img src="../#GetAlbumsRet.arAlbums[iAlbum][5]#" alt="#GetAlbumsRet.arAlbums[iAlbum][1]#" border="0" />
				</td>
				<td width="150">
					<a href="albumView.cfm?iAlbum=#iAlbum#">#GetAlbumsRet.arAlbums[iAlbum][1]#</a>
				</td>
				<td width="300">
					<em>#GetAlbumsRet.arAlbums[iAlbum][2]#</em>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<p>You can choose to remove this album from the xml only and leave the folder with the images in the gallery folder, or you can choose to remove the album from the xml as well as remove the album folder from the gallery folder and all its contents.  If you choose to remove the folder and its contents they will be deleted and will not be able to be retrieved.  <strong>THIS IS A PERMANANT ACTION.</strong>.  Also, if you choose to remove the album from the xml, but not the folder and its contents from the gallery, it will be impossible to add a gallery by the same name untill you delete the folder or rename it on the server, something you will not be able to do from within this manager.</p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<a href="albums.cfm"><button class="req">Cancel</button></a>
				</td>
			</tr>
			<tr>
				<form action="albumsAction.cfm" method="Post">
					<input type="hidden" name="Action" value="AlbumRemove" />
					<input type="hidden" name="iAlbum" value="#iAlbum#" />
					<input type="hidden" name="DirectoryName" value="#GetAlbumsRet.arAlbums[iAlbum][1]#" />
					<input type="hidden" name="DeleteDir" value="0" />
					<td colspan="3">
						<input type="submit" value="Remove the Album, leave the contents" />
					</td>
				</form>
			</tr>
			<tr>
				<form action="albumsAction.cfm" method="Post">
					<input type="hidden" name="Action" value="AlbumRemove" />
					<input type="hidden" name="iAlbum" value="#iAlbum#" />
					<input type="hidden" name="DirectoryName" value="#GetAlbumsRet.arAlbums[iAlbum][1]#" />
					<input type="hidden" name="DeleteDir" value="1" />
					<td colspan="3">
						<input type="submit" value="Remove the Album and it's contents" />
					</td>
				</form>
			</tr>
		</table>
	</div>
	</cfoutput>
	
</div>

</body>
</html>