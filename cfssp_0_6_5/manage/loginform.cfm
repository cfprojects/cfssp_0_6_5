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
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: Login</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfinclude template="include/ss.cfm" />
</head>

<body>
		
<cfinclude template="include/header.cfm" />

<cfoutput>
<div id="container" class="clearfix">

	<cfinclude template="include/nav.cfm" />

	<div id="main">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / <a href="loginform.cfm">Login Form</a> /
		</div>
		
		<cfif isDefined("url.error")>
			<h2 style="color:blue">#Url.error#</h2>
		</cfif>
		
		
		<fieldset style="500px">
			<legend>Login</legend>
			<table>
				<form action="login.cfm" method="post" name="LoginForm">
				
				<tr>
					<td><strong>Username:</strong></td>
					<td><input type="text" name="Username" value="" size="35" class="req"/></td>
				</tr>
	
				<tr>
					<td><strong>Password:</strong></td>
					<td><input type="password" name="Password" value="" size="35" class="req"/></td>
				</tr>
				<cfif Application.Config.Login.AllowRemember>
					<tr>
						<td><strong>Remember?*</strong></td>
						<td><input type="checkbox" name="Remember" /></td>
					</tr>
				</cfif>
				<input type="hidden" name="action" value="Login" />
				
				<tr>
					<td />
					<td><input class="opt" type="submit" value="Login" size="20" /></td>
				</tr>
	
				</form>
				<tr>
					<td colspan="2">
						<div class="key">* Form fields this color are required</div>
					</td>
				</tr>
			</table>
		</fieldset>
		<cfif Application.Config.Login.AllowRemember>
			<p>If you check the remember box then you will not be prompted to login every time you access the application, unless you manually log out.  <strong>Note:</strong> Using this feature sets two cookies on your machine, your username and your password (hashed if hashing is turned on in AppConfig.xml).  <em>If you feel this is a security concern, please do not use the remember checkbox.</em>  You can also restrict this box and this note from showing by editing the login/remember value in the AppConfig.xml file.</p>
		</cfif>
	</div>
	
</div>
</cfoutput>

</body>
</html>