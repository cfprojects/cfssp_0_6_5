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
 
<cfif NOT Session.login.UserInRole("UAdd") 
	AND NOT Session.Login.UserInRole("UEdit") 
	AND NOT Session.Login.UserInRole("URemove") 
	AND NOT Session.Login.UserInRole("GlobalAdmin")>
	<cflocation url="insufficientRoles.cfm" />	
</cfif>

<cfif NOT IsDefined("url.iuser") OR NOT isNumeric(url.iuser)>
	<cflocation url="users.cfm" />
</cfif>

<cfset ReadUsersXMLRet = Application.Users.ReadUsersXML() />
<cfset Variables.numUsers = ArrayLen(ReadUsersXMLRet.AdminUsers.XMLChildren) />

<cfif url.iuser GT Variables.numUsers>
	<cflocation url="users.cfm" />
</cfif>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager: User Management</title>
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
			<a href="index.cfm">Home</a> / <a href="users.cfm">User Management</a> / <a href="userDetail.cfm?iuser=#url.iUser#">User Detail: #ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</a> /
		</div>
		
		<h1>User Detail: #ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</h1>
		
		<p>Name: <strong>#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</strong></p>
		<p>Email: <strong>#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["email"]#</strong></p>
		<p>Username: <strong>#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["Username"]#</strong></p>
		<p>Roles: <strong>#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"]#</strong></p>
		<p>Password was set on: <strong>#DateFormat(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["passwordset"], "mmm-dd-yyyy")#</strong></p>
		<hr />
			<!--- because we dont want someone removing themselves while they are logged in, for many many reasons, we will check to see if the username of this record is the same as the username of the person being viewed --->
		<cfif Session.Login.Username NEQ ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["Username"]>
			<cfif Session.Login.UserInRole("URemove") OR Session.Login.UserInRole("GlobalAdmin")>
				<p>Are you sure that you want to remove this user?  This action is non-reversable</p>
				<p><form action="usersAction.cfm" method="post">
					<input type="hidden" name="iuser" value="#url.iuser#" />
					<input type="hidden" name="action" value="UserRemove" />
					<input type="submit" value="Yes, Remove this user" />
					</form></p>
				<p><a href="users.cfm"><button class="req">Cancel</button></a>
			</cfif>
		</cfif>
		
	</cfoutput>
	
</div>

</body>
</html>