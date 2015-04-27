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
 
<!--- if the user is already logged in, do not run any of this page, send them to the home page --->
<cfif Session.Login.LoggedIn>
	<cflocation url="index.cfm" />
</cfif>

<cfif IsDefined("form.action") and Form.Action EQ "Login">
	<cfif NOT IsDefined("form.username") OR NOT Len(Trim(Form.Username))>
		<cflocation url="loginform.cfm?error=Username Required" />
	</cfif>
	<cfif NOT IsDefined("form.password") OR NOT Len(Trim(Form.Password))>
		<cflocation url="loginform.cfm?error=Password Required" />
	</cfif>
	
	<cfset Session.Login.Login(1, Form.Username, Form.Password, Application.Config.Users.HashPasswords) />
	
	<cfif Session.Login.LoggedIn>
		<cfif IsDefined("Form.Remember")>
			<cfset Session.Login.Remember(Form.Username, Form.Password, Application.Config.Users.HashPasswords) />
		</cfif>
		<cflocation url="index.cfm" />
	<cfelse>
		<cflocation url="loginform.cfm?error=Invalid Login" />
	</cfif>
<cfelse>
	<cflocation url="loginform.cfm" />
</cfif>