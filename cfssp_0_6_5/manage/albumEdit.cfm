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
 
<cfif NOT Session.Login.UserInRole("AEdit")  
	AND NOT Session.Login.UserInRole("GlobalAdmin")>
	<cflocation url="insufficientRoles.cfm" />	
</cfif>

<cfif Not IsDefined("url.iAlbum") OR NOT isNumeric(url.iAlbum)>
	<cflocation url="albums.cfm?error=No Album Specified" />
</cfif>

<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

<cfif GetAlbumsRet.Done>
	<cfdump var="#GetAlbumsRet#" />
</cfif>

<cfif GetAlbumsRet.numAlbums LT url.iAlbum>
	<cflocation url="albums.cfm?error=Invaid Album" />
</cfif>		


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: Edit Album</title>
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
			<a href="index.cfm">Home</a> / <a href="albums.cfm">Albums</a> / <a href="AlbumEdit.cfm?ialbum=#url.ialbum#">Edit Album: #GetAlbumsRet.arAlbums[url.iAlbum][1]#</a> / 
		</div>
		
		<h1>Edit Album: #GetAlbumsRet.arAlbums[url.iAlbum][1]#</h1>
		
		<cfif IsDefined("url.error")>
			<h2 style="color:red">#url.Error#</h2>
		</cfif>
		<cfif IsDefined("url.success")>
			<h2 style="color:blue">#url.success#</h2>
		</cfif>	
	<table>
		<tr>
			<td>		
				<table align="left" width="100%">
					<tr>
						<td align="center" valign="center">
							<img src="../#GetAlbumsRet.arAlbums[url.iAlbum][5]#" alt="#GetAlbumsRet.arAlbums[url.iAlbum][1]#" border="0" class="alThumb" />
						</td>
					</tr>
					<tr>
						<td>
							<strong>Title:</strong> <a href="albumView.cfm?iAlbum=#url.iAlbum#">#GetAlbumsRet.arAlbums[url.iAlbum][1]#</a>
						</td>
					</tr>
					<tr>
						<td>
							<strong>ID:</strong> #GetAlbumsRet.arAlbums[url.iAlbum][8]#
						</td>
					</tr>
					<tr>
						<td>
							<strong>Description:</strong> <em>#GetAlbumsRet.arAlbums[url.iAlbum][2]#</em>
						</td>								
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<cfif Session.Login.UserInRole("AEdit") OR Session.Login.UserInRole("GlobalAdmin")>
					<fieldset>
						<legend>Edit This Album</legend>
						
						<cfform action="albumsAction.cfm" method="Post" enctype="multipart/form-data" name="AlbumEditForm" >
						<table>
						
						<tr>
							<td><strong>Title:</strong></td>
							<td><cfinput type="text" name="Title" maxlength="30" required="True" message="Please enter a title for this album" size="35" value="#GetAlbumsRet.arAlbums[url.iAlbum][1]#" class="req" /></td>
						</tr>
						
						<tr>
							<td><strong>ID:*</strong></td>
							<td><cfinput type="text" name="AlbumXMLID" maxlength="30" required="True" message="Please enter an id for this album" size="11" value="#GetAlbumsRet.arAlbums[url.iAlbum][8]#" class="req" /></td>
						</tr>
						
						<tr>
							<td><strong>Description:</strong></td>
							<td><cfinput type="text" name="Description" maxlength="65" size="55" value="#GetAlbumsRet.arAlbums[url.iAlbum][2]#" /></td>
						</tr>
						
						<tr>
							<td colspan="2">
								<p>You can see the thumbnail for this album above.  <br />
								If you want to change this thumbnail, upload a new thumbnail below. <br />
								If you do not want to change the thumbnail then leave the fild below blank.</p>
							</td>
						</tr>
						
						<tr>
							<td><strong>Album Thumbnail:</strong></td>
							<td><input type="file" value="" size="45" name="tn" class="opt" /></td>
						</tr>
						
						<input type="hidden" name="Action" value="AlbumEdit" />
						<input type="hidden" name="iAlbum" value="#url.iAlbum#" />
						
						<tr>
							<td />
							<td><input class="opt" type="submit" value="Edit This Album" size="20" /></td>
						</tr>
			
						</cfform>
					<tr>
						<td colspan="2"><div class="key">* Form fields this color are required</td>
					</tr>
				</cfif>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<p>* The ID of the album is required, and should contain only number and letters and the underscore _ character.  Please do not use spaces or puncuation.</p>
			</td>
		</tr>
	</table>
		
		
	</div>
	</cfoutput>
	
</div>

</body>
</html>