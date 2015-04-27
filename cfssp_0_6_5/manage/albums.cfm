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

<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

<cfif GetAlbumsRet.Done>
	<cfdump var="#GetAlbumsRet#" />
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: Albums</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfinclude template="include/ss.cfm" />
</head>

<body>
		
<cfinclude template="include/header.cfm" />

<div id="container" class="clearfix">

	<cfinclude template="include/nav.cfm" />
	
	<cfoutput>
	<div id="main" class="clearfix">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / <a href="albums.cfm">Albums</a> /
		</div>
		
		<h1>Album Manager</h1>
		
		<cfif IsDefined("url.error")>
			<h1 style="color:red">#url.Error#</h1>
		</cfif>
		
		<cfif IsDefined("url.success")>
			<h1 style="color:blue">#url.success#</h1>
		</cfif>
		
		<h3>Current Albums</h3> 
		
		<table align="left" width="100%" style="float:top">
			<tr>
				<td>					
					<table align="left" width="100%" style="float:top">
						<cfif GetAlbumsRet.numAlbums>
							<cfloop from="1" to="#GetAlbumsRet.numAlbums#" index="iAlbum">
								<cfset Variables.Class = IIF(ialbum MOD 2 EQ 0, "''", "'alt'")>
								<tr class="#Variables.class#">
									<td align="right" valign="center" width="50">
										<img src="../#GetAlbumsRet.arAlbums[iAlbum][5]#" alt="#GetAlbumsRet.arAlbums[iAlbum][1]#" border="0" class="alThumb"/>
									</td>
									<td width="150">
										<a href="albumView.cfm?iAlbum=#iAlbum#">#GetAlbumsRet.arAlbums[iAlbum][1]#</a>
										<cfif GetAlbumsRet.arAlbums[iAlbum][8] EQ "">
											<em>(no ID)</em>
										<cfelse>
											<em>(#GetAlbumsRet.arAlbums[iAlbum][8]#)</em>
										</cfif>
									</td>
									<td width="300">
										<em>#GetAlbumsRet.arAlbums[iAlbum][2]#</em>
									</td>
									
									<cfif Session.Login.UserInRole("AEdit") OR Session.Login.UserInRole("GlobalAdmin")>
										<form action="albumEdit.cfm" method="get">
											
											<input type="hidden" name="iAlbum" value="#iAlbum#" />
											<td width="50">
												<input type="submit" value="Edit"/>
											</td>
										</form>
									<cfelse>
										<td width="50">
											<button class="disabled">Edit</button>
										</td>
									</cfif>
									<cfif Session.Login.UserInRole("ARemove") OR Session.Login.UserInRole("GlobalAdmin")>
										<form action="albumRemove.cfm" method="Get">
											<input type="hidden" name="iAlbum" value="#iAlbum#" />
											<td width="50">
												<input type="submit" value="Remove" />
											</td>
										</form>
									<cfelse>
										<td width="50">
											<button class="remove">Remove</button>
										</td>
									</cfif>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td>
									<em>(There are currently no albums)</em>
								</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		
		<cfif Session.Login.UserInRole("ACreate") OR Session.Login.UserInRole("GlobalAdmin")>
			
			<cfif IsDefined("url.Error")>
				<tr>
					<td>
						<h1 style="color:red">#Url.Error#</h1>
					</td>
				</tr>
			</cfif>
			<cfform action="albumsAction.cfm" method="Post" enctype="multipart/form-data" name="AlbumAddForm">
			<tr>
				<td>
					<fieldset style="width:500px">
						<legend>Create a New Album</legend>
					<table align="left" width="100%" style="float:top">
						<tr>
							<td><strong>Title:</strong></td>
							<td><cfinput type="text" name="Title" maxlength="30" required="True" message="Please enter a title for the new album" size="35" class="req" /></td>
						</tr>
						<tr>
							<td><strong>ID*:</strong></td>
							<td><cfinput type="text" name="AlbumXMLID" maxlength="30" required="True" message="Please enter an ID for the new album" size="11" class="req" /></td>
						</tr>
			
						<tr>
							<td><strong>Description:</strong></div>
							<td><cfinput type="text" name="Description" maxlength="65" size="55" class="opt" /></td>
						</tr>
						
						<tr>
							<td><strong>Album Thumbnail:</strong></div>
							<td><input type="file" value="" size="45" name="tn" class="opt" /></td>
						</tr>
						
						<input type="hidden" name="Action" value="AlbumCreate" />
						
						<tr>
							<td></td>
							<td><input class="opt" type="submit" value="Create Album" size="20" /></td>
						</tr>
						<tr>
							<td colspan="2">
							<br />
								<div class="key">* Form fields this color are required</div>
							</td>
						</tr>
					</table>
					</fieldset>
				</td>
			</tr>
			</cfform>
			<tr>
				<td>
					<p>* The ID of the album is required, and should contain only number and letters and the underscore _ character.  Please do not use spaces or puncuation.</p>
				</td>
			</tr>
		</cfif>
		</table>
	</div>
	</cfoutput>
	
</div>

</body>
</html>