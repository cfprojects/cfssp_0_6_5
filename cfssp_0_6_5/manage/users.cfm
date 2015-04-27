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

<cfset ReadUsersXMLRet = Application.Users.ReadUsersXML() />
<cfset Variables.numUsers = ArrayLen(ReadUsersXMLRet.AdminUsers.XMLChildren) />


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
	<div id="main" class="clearfix">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / <a href="users.cfm">User Management</a> /
		</div>
		
		<h1>User Management</h1>
		
		<table align="left" width="100%" style="float:top">
		<cfif Variables.numUsers>
			<tr>
				<td>
					<table align="left" width="100%" style="float:top">
						<tr>
							<td>
								<strong>Name</strong>
							</td>
							<td>
								<strong>Email</strong>
							</td>
							<td>
								<strong>Username</strong>
							</td>
							<td>
							
							</td>
							<cfif Session.Login.UserInRole("UEdit") OR Session.Login.UserInRole("GlobalAdmin")>
								<td>
								
								</td>
							</cfif>
							<cfif Session.Login.UserInRole("URemove") OR Session.Login.UserInRole("GlobalAdmin")>
								<td>
								
								</td>
							</cfif>
						</tr>
						<cfloop from="1" to="#Variables.numUsers#" index="i">
							<cfset Variables.Class = IIF(i MOD 2 EQ 0, "''", "'alt'")>
							<tr class="#Variables.class#">
								<td>
									#ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["name"]#
								</td>
								<td>
									<cfif ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["email"] EQ "">
										<em class="small">(no email)</em>
									<cfelse>
										<a href="mailto:#ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["email"]#">
											#ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["email"]#
										</a>
									</cfif>
								</td>
								<td>
									#ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["username"]#
								</td>
								<td>
									<a href="userDetail.cfm?iuser=#i#">
										<button>View</button>
									</a>
								</td>
								<cfif Session.Login.UserInRole("UEdit") OR Session.Login.UserInRole("GlobalAdmin")>
									<form action="userEdit.cfm" method="get">
										<input type="hidden" name="iUser" value="#i#" />
										<td>
											<input type="submit" value="Edit" />
										</td>
									</form>
								<cfelse>
									<td>
										<button class="disabled">Edit</button>
									</td>
								</cfif>
								<cfif Session.Login.Username NEQ ReadUsersXMLRet.AdminUsers.XMLChildren[i].XMLAttributes["Username"]>
									<cfif Session.Login.UserInRole("URemove") OR Session.Login.UserInRole("GlobalAdmin")>
										<form action="userRemove.cfm" method="Get">
											<td>
												<input type="hidden" name="iuser" value="#i#" />
												<input type="submit" value="Remove" />
											</td>
										</form>
									<cfelse>
										<td>
											<button class="disabled">Remove</button>
										</td>
									</cfif>
								<cfelse>
									<td>
										<button class="disabled">Remove</button>
									</td>
								</cfif>
							</tr>
						</cfloop>
				</table>
		<cfelse>
			<tr>
				<td>
					<em>(There are no users)</em>
				</td>
			</tr>
		</cfif>
		
		<cfif Session.Login.UserInRole("UAdd") OR Session.Login.UserInRole("GlobalAdmin")>
			
			<cfif IsDefined("url.Error")>
				<tr>
					<td>
						<h2 style="color:red">#Url.Error#</h2>
					</td>
				</tr>
			</cfif>
				<form action="usersAction.cfm" method="post" name="AddUserForm">
			<tr>
				<td>
					<fieldset>
						<legend style="font-weight:bold">Add User</legend>
						<table align="left" width="100%" style="float:top">
							<tr>
								<td><strong>Name:</strong></td>
								<td><input type="text" name="Name" value="" size="45" class="req"/></td>
							</tr>
				
							<tr>
								<td><strong>Email:</strong></td>
								<td><input type="text" name="email" value="" size="45" class="opt"/></td>
							</tr>
							
							<tr>
								<td><strong>Username:</strong></td>
								<td><input type="text" name="username" value="" size="45" class="req"/></td>
							</tr>
							
							<tr>
								<td><strong>Password:</strong></td>
								<td><input type="password" name="Password" value="" size="25" class="req"/></td>
							</tr>
							
							<tr>
								<td><strong>Repeat Password:</strong></td>
								<td><input type="password" name="password2" value="" size="25" class="req"/></td>
							</tr>
							
							<tr>
								<td valign="top"><strong>Roles:</strong></td>
								<td>
									<table>
										<tr>
											<td>
												<input type="checkbox" name="Roles" value="GlobalAdmin" id="GlobalAdmin"/><label for="GlobalAdmin"><strong>GlobalAdmin</strong></label>
											</td>
											<td>
											</td>
											<td>
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="Roles" value="ACreate" id="ACreate" /><label for="ACreate">Album Create</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="AEdit" id="AEdit" /><label for="AEdit">Album Edit</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="ARemove" id="ARemove" /><label for="ARemove">Album Remove</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="Roles" value="IAdd" id="IAdd" /><label for="IAdd">Image Add</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="IEdit" id="IEdit" /><label for="IEdit">Image Edit</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="IRemove" id="IRemove" /><label for="IRemove">Image Remove</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="Roles" value="UAdd" id="UAdd" /><label for="UAdd">User Add</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="UEdit" id="UEdit" /><label for="UEdit">User Edit</label>
											</td>
											<td>
												<input type="checkbox" name="Roles" value="URemove" id="URemove" /><label for="URemove">User Remove</label>
											</td>
										</tr>
									</table>
								</td>							
							</tr>
													
							<input type="hidden" name="action" value="UserCreate" />
							<input type="hidden" name="name_required" />
							<input type="hidden" name="username_required" />
							<input type="hidden" name="password_required" />
							<input type="hidden" name="password2_required" />
							<input type="hidden" name="roles_required" />
							
							<tr>
								<td></td>
								<td><input class="opt" type="submit" value="Add This User" size="20" /></td>
							</tr>
				
							</form>
				
						</table>
					</fieldset>
				</td>
			</tr>
			
			<!--- <div class="key">* Form fields this color are required</div> --->
		</cfif>
		</table>
	</cfoutput>
	<p><strong>A note about roles:</strong> GlobalAdmin is a catch-all role.  If you give someone GloabalAdmin roles, there is no need to give them any other role.  GlobalAdmin can do everything in the manager.  Basically GlobalAdmin is like giving the person all the other roles together. Only if you want to limit someone from doing one or more particular action should you use the other roles.</p>
</div>

</body>
</html>