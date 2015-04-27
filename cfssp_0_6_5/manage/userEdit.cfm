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
 
<cfif NOT Session.Login.UserInRole("UEdit")
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
			<a href="index.cfm">Home</a> / <a href="users.cfm">User Management</a> / <a href="userDetail.cfm?iuser=#url.iUser#">User Detail: #ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</a> / <a href="userEdit.cfm?iuser=#url.iUser#">Edit User: #ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</a> /
		</div>
		<br />
		<fieldset>
				<legend>Edit User: #ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#</legend>
		<table>
			
			<cfif IsDefined("url.Error")>
				<tr>
					<td colspan="2">
						<h2 style="color:red">#Url.Error#</h2>
					</td>
				</tr>
			</cfif>
			<form action="usersAction.cfm" method="post" name="AddUserForm">
			
			<tr>
				<td><strong>Name:</strong></td>
				<td><input type="text" name="Name" value="#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["name"]#" size="45" class="req"/></td>
			</tr>

			<tr>
				<td><strong>Email:</strong></td>
				<td><input type="text" name="email" value="#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["email"]#" size="45" class="opt"/></td>
			</tr>
			
			<tr>
				<td><strong>Username:</strong></td>
				<td><input type="text" name="username" value="#ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["Username"]#" size="45" class="req"/></td>
			</tr>
			
			<!--- <div class="row clearfix">
				<div class="c x2 al"><strong>Password:</strong></div>
				<div class="c x6 al"><input type="password" name="Password" value="" size="25" class="req"/></div>
			</div>
			
			<div class="row clearfix">
				<div class="c x2 al"><strong>Repeat Password:</strong></div>
				<div class="c x6 al"><input type="password" name="password2" value="" size="25" class="req"/></div>
			</div> --->
			
			<tr>
				<td valign="top"><strong>Roles:</strong></td>
				<td>
					<table>
						<tr>
							<td><input type="checkbox" name="Roles" value="GlobalAdmin" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "GlobalAdmin")>checked="checked" </cfif>/>GlobalAdmin</td>
							<td />
							<td />
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="Roles" value="ACreate" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "ACreate")>checked="checked" </cfif>/>Album Create
							</td>
							<td>
								<input type="checkbox" name="Roles" value="AEdit" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "AEdit")>checked="checked" </cfif>/>Album Edit
							</td>
							<td>
								<input type="checkbox" name="Roles" value="ARemove" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "ARemove")>checked="checked" </cfif>/>Album Remove
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="Roles" value="IAdd" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "IAdd")>checked="checked" </cfif>/>Image Add
							</td>
							<td>
								<input type="checkbox" name="Roles" value="IEdit" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "IEdit")>checked="checked" </cfif>/>Image Edit
							</td>
							<td>
								<input type="checkbox" name="Roles" value="IRemove" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "IRemove")>checked="checked" </cfif>/>Image Remove
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="Roles" value="UAdd" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "UAdd")>checked="checked" </cfif>/>User Add
							</td>
							<td>
								<input type="checkbox" name="Roles" value="UEdit" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "UEdit")>checked="checked" </cfif>/>User Edit
							</td>
							<td>
								<input type="checkbox" name="Roles" value="URemove" <cfif ListContains(ReadUsersXMLRet.AdminUsers.XMLChildren[url.iuser].XMLAttributes["roles"], "URemove")>checked="checked" </cfif>/>User Remove 
							</td>
						</tr>
					</table>
				</td>
			</tr>
				
			<input type="hidden" name="action" value="UserEdit" />
			<input type="hidden" name="iuser" value="#url.iuser#" />
			<input type="hidden" name="name_required" />
			<input type="hidden" name="username_required" />
			<input type="hidden" name="roles_required" />
			
			<tr>
				<td />
				<td><input class="req" type="submit" value="Edit This User" size="20" /></td>
			</tr>
			<tr>
				<td />
				<td><a href="users.cfm"><button>Cancel</button></a></td>
			</tr>
			</form>
			<tr>
				<td colspan="2">
					<div class="key">* Form fields this color are required</div>
				</td>
			</tr>
			
		</table>
		</fieldset>
	
		
	</cfoutput>
	
</div>

</body>
</html>