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
 
<!--- <cfdump var="#Form#" /> --->
<cfif NOT Session.login.UserInRole("UAdd") 
	AND NOT Session.Login.UserInRole("UEdit") 
	AND NOT Session.Login.UserInRole("URemove") 
	AND NOT Session.Login.UserInRole("GlobalAdmin")>
	<cflocation url="insufficientRoles.cfm" />	
</cfif>

<cfif IsDefined("Form.Action")>
	<cfswitch expression="#Form.Action#">
		<cfcase value="UserCreate">
			<!--- first thing we want to do is 
				check to make sure that the two passwords supplied match, 
				if not, send back an error --->
			<cfif Form.Password NEQ Form.Password2>
				<cflocation url="users.cfm?error=Passwords did not match" />
			</cfif>
			
			<!--- also lets check to make sure that they have specified 
				that the person has at least one role,
				if not give them an error --->
			<cfif NOT isDefined("Form.roles") OR Len(Trim(Form.Roles)) EQ 0>
				<cflocation url="users.cfm?error=Please specify at least one role for the user" />
			</cfif>
			
			<!--- alright so we got past that check,
				now we need to make sure that someone else 
				doesnt already exist with that username or email address --->
			<cflock name="usersXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.Users#" method="UserCheck" returnvariable="UserCheckRet">
					<cfinvokeargument name="Email" value="#Form.email#"/>
					<cfinvokeargument name="Username" value="#Form.Username#"/>
				</cfinvoke>
			</cflock>
			
			<!--- if the check comes back positive, 
				then send them back to the form with an error --->
			<cfif UserCheckRet.result>
				<cflocation url="users.cfm?error=Username or Email already taken" />
			</cfif>
			
			<!--- okay so if we are past those checks then its cool to go ahead
				and add the user to the xml file --->
			<cflock name="usersXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.Users#" method="UserCreate" returnvariable="UserCreateRet">
					<cfinvokeargument name="Name" value="#Form.Name#"/>
					<cfinvokeargument name="Email" value="#Form.Email#"/>
					<cfinvokeargument name="Username" value="#Form.Username#"/>
					<cfinvokeargument name="Password" value="#Form.Password#"/>
					<cfinvokeargument name="HashPassword" value="#Application.Config.Users.HashPasswords#"/>
					<cfinvokeargument name="Roles" value="#Form.Roles#"/>
				</cfinvoke>
			</cflock>
			
			<!--- now just one final check to make sure that the create succeeded.
				if it did, send them back to the users page where they should now see the new user,
				if not then send them to an error page --->
			<cfif UserCreateRet.Done>
				<!--- the following line is commented out, 
					for now we just want to dump the results 
					of the create if something went wrong,
					this will be changed in the 1.0 release.
				 --->
				 <!--- <cflocation url="error.cfm?error=UserCreate Failed" /> --->
				 <cfdump var="#UserCreateRet#" />
				 <cfabort />
			<cfelse>
				<cflocation url="users.cfm" />
			</cfif>
		</cfcase>
		<cfcase value="UserEdit">
			
			<!--- lets check to make sure that they have specified 
				that the person has at least one role,
				if not give them an error --->
			<cfif NOT isDefined("Form.roles") OR Len(Trim(Form.Roles)) EQ 0>
				<cflocation url="userEdit.cfm?iuser=#form.iuser#&error=Please specify at least one role for the user" />
			</cfif>
			
			<!--- alright so we got past that check,
				now we need to make sure that someone else 
				doesnt already exist with that username or email address --->
			<cflock name="usersXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.Users#" method="UserCheck" returnvariable="UserCheckRet">
					<cfinvokeargument name="Email" value="#Form.email#"/>
					<cfinvokeargument name="Username" value="#Form.Username#"/>
				</cfinvoke>
			</cflock>
			
			<!--- if the check comes back positive, 
				then check to see if it is the same iuser as the current one.  
				if not then its a different person, and you should error out --->
			<cfif UserCheckRet.result>
				<cfif UserCheckRet.iuser NEQ Form.iUser>
					<cflocation url="userEdit.cfm?iuser=#form.iuser#&error=Username or Email already taken" />
				</cfif>
			</cfif>
			
			<!--- if we have gotten past these checks then go ahead and edit the user --->
			<cflock name="usersXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.Users#" method="UserEdit" returnvariable="UserEditRet">
					<cfinvokeargument name="iUser" value="#form.iuser#"/>
					<cfinvokeargument name="Name" value="#Form.name#"/>
					<cfinvokeargument name="Email" value="#form.email#"/>
					<cfinvokeargument name="Username" value="#form.Username#"/>
					<cfinvokeargument name="Roles" value="#Form.roles#"/>
				</cfinvoke>
			</cflock>
			
			<!--- now just one final check to make sure that the edit succeeded.
				if it did, send them back to the users page where they should now see the new values for the user,
				if not then send them to an error page --->
			<cfif UserEditRet.Done>
				<!--- the following line is commented out, 
					for now we just want to dump the results 
					of the edit if something went wrong,
					this will be changed in the 1.0 release.
				 --->
				 <!--- <cflocation url="error.cfm?error=UserCreate Failed" /> --->
				 <cfdump var="#UserEditRet#" />
				 <cfabort />
			<cfelse>
				<cflocation url="userDetail.cfm?iuser=#form.iuser#" />
			</cfif>			
			
		</cfcase>
		<cfcase value="UserRemove">
			<cflock name="usersXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
				<cfinvoke component="#Application.Users#" method="UserRemove" returnvariable="UserRemoveRet">
					<cfinvokeargument name="iUser" value="#form.iuser#"/>
				</cfinvoke>
			</cflock>
			
			<!--- check to make sure that the remove was successful, if not 
				send them to an error page, if so then send them back to the users index page --->
			<cfif UserRemoveRet.Done>
				<!--- the following line is commented out, 
					for now we just want to dump the results 
					of the remove if something went wrong,
					this will be changed in the 1.0 release.
				 --->
				 <!--- <cflocation url="error.cfm?error=UserRemove Failed" /> --->
				 <cfdump var="#UserRemoveRet#" />
				 <cfabort />
			<cfelse>
				<cflocation url="users.cfm" />
			</cfif>
		</cfcase>
		<!--- 
		<cfcase value="UserChangePassword">
		
		</cfcase> 
		--->
		<cfdefaultcase>
			<cflocation url="users.cfm" />	
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cflocation url="users.cfm" />	
</cfif>