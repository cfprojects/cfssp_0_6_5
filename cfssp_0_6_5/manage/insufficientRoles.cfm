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
	
	<title>SlideShowPro CF Manager: Insufficient Roles</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfinclude template="include/ss.cfm" />
</head>

<body>
		
<cfinclude template="include/header.cfm" />

<div id="container" class="clearfix">

	<cfinclude template="include/nav.cfm" />

	<div id="main">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / <a href="insufficientRoles.cfm">Insufficient Roles</a> /
		</div>
		
		<h1>Insufficient Roles</h1>
	
		<p>You have tried to access a part of the application, or perform an action that you do not have sufficent roles to access.  If you feel you have reached this message in error, please check with the administrator.</p>
		<cfif NOT Session.Login.LoggedIn>
			<p style="font-weight:bold">You have reached this message because your session has timed out. Just log in again and try your action again.</p>
		<cfelse>
			<cfoutput>
				<p>You have the following roles:
					<ul>
						<cfloop list="#Session.Login.Roles#" index="iRoles">
							<li>#iRoles#</li>
						</cfloop>
					</ul>
				</p>
			</cfoutput>
		</cfif>
		
	</div>
	
</div>

</body>
</html>