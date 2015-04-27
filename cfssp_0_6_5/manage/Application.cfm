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
 
<cfapplication name="cfsspManage" sessionmanagement="true" sessiontimeout="#CreateTimeSpan(0,1,0,0)#" />
	
	<cfprocessingdirective suppresswhitespace = "Yes">
	
	<cfparam name="Application.ConfigLoaded" default="0" type="numeric" />
	
	<cfif NOT Application.ConfigLoaded OR IsDefined("url.ReloadAppConfig") or IsDefined("url.reinit")>
		<!--- The following values do not need to be changed unless you have set up your config folder differently. --->
		<cfset Application.Paths.AppConfigPath = "../config/AppConfig.xml" />
		<cfset Application.Paths.UsersXMLPath = "../config/Users.xml" />
		<cfset Application.Paths.SSPXMLPath = "../ssp.xml" />
		
		<cfset Application.CFSSP = CreateObject("component", "cfc.cfssp").initCFSSP(Application.Paths.AppConfigPath) />
		
		<cfset Application.CFSSP.LoadAppConfig() />
		
		<!--- this value is here for testing purposes and will be changed nearing the 1.0 release.
		It is basically going to reload the Application Config files with every page request which 
		does create some overhead.  If you change the value to 1 it will only load when the 
		application is started. --->
		
		<cfset Application.ConfigLoaded = 0 />
	</cfif>
	
	<cfif NOT IsDefined("Session.Login") or IsDefined("url.clearlogin") or IsDefined("url.reinit")>
		<cfset Session.Login = CreateObject("component", "cfc.login").initlogin(Application.Paths.UsersXMLPath) />
	</cfif>
	
	<cfif NOT IsDefined("Application.Users") or isDefined("url.ClearUsers") or IsDefined("url.reinit")>
		<cfset Application.Users = CreateObject("component", "cfc.users").initUsers(Application.Paths.UsersXMLPath) />
	</cfif>
	
	<cfif NOT IsDefined("Application.SlideShow") or IsDefined("url.ClearSlideShow") or IsDefined("url.reinit")>
		<cfset Application.SlideShow = CreateObject("component", "cfc.SlideShow").InitSlideShow(Application.Paths.SSPXMLPath) />
	</cfif>	
	
	<cfif IsDefined("url.reinit") or IsDefined("url.clearlogin") or IsDefined("url.clearusers")>
		<cflocation url="index.cfm" />
	</cfif>
	
	<cfif IsDefined("Cookie.username") AND IsDefined("Cookie.password") AND NOT Session.Login.LoggedIn>
		<cfset Variables.CookieLoginTry = Session.Login.Login(1, Cookie.username, Cookie.password, 0) />
	</cfif>
	
	</cfprocessingdirective>