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
<cfcomponent extends="base" output="false">
	
	<cfsilent>
		
		<!--- component methods --->
		
		<cffunction name="ReadUsersXML" access="public" output="true" returntype="string">
			
			<!--- initalize local vars --->
			<cfset VAR Output = "" />
			
			<cfsilent>
				<!--- run the initMethod --->
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cflock type="exclusive" name="UsersXML" timeout="#CreateTimeSpan(0,0,2,0)#">
						<cftry>
							<cffile action="read" file="#ExpandPath(Variables.UsersXMLLocation)#" variable="Output" />
						<cfcatch>
							<cfthrow message="ReadUsersXML Failed" />
						</cfcatch>
						</cftry>
					</cflock>
				</cfif>
				
				<cfif NOT Variables.Done>
					<cftry>
						<cfset Output = XMLParse(Output) />
					<cfcatch>
						<cfthrow message="ReadUsersXML Parse Failed" />
					</cfcatch>
					</cftry>
				</cfif>
				
				<!--- run the term method --->
				<cfset Term(arguments) />
			</cfsilent>
		<cfreturn Output />
		</cffunction>
		
		
		<cffunction name="InitLogin" access="public" returntype="login" output="false">
			<cfargument name="UsersXMLLocation" required="True" type="String" />
			<cfsilent>
				<cfset This.LoggedIn = 0 />
				<cfset This.Username = "Guest" & session.CFID />
				<cfset This.UserID = Session.CFID & "00001" />
				<cfset This.CurrentPage = "" />
				<cfset This.CurrentArea = "" />
				<cfset This.Roles = "" />
				<cfset This.FullName = "Guest" />
				<cfset This.PasswordSetTS = "" />
				<cfset This.EmailAddress = "" />
				
				<cfset Variables.UsersXMLLocation = Arguments.UsersXMLLocation />
			</cfsilent>
		<cfreturn this />
		</cffunction>
		
		<cffunction name="login" access="public" returntype="boolean" output="true">
			<cfargument name="debug" type="boolean" required="true" />
			<cfargument name="Username" type="string" required="true" />
			<cfargument name="Password" type="string" required="true" />
			<cfargument name="HashPassword" type="boolean" required="true" />
			
			<cfset VAR LocalOutput = 0 />
			<cfset VAR UsersXML = ReadUsersXML() />			
			<cfset VAR numUsers = ArrayLen(UsersXML.AdminUsers.XMLChildren) />		
			
			<cfsilent>
				<cfset init() />
				
				<!--- qualify the user, in other words, find the username in the xml, and check their password. --->
				<cfif NOT Variables.Done>
					<cfif NumUsers>
						<cfloop from="1" to="#NumUsers#" index="i">
							<cfif UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["username"] EQ Arguments.Username>
								<cfset SetSuccessCode("Username Found") />
								<cfif Arguments.HashPassword>
									<cfif UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["password"] EQ Hash(Arguments.password)>
										<cfset SetSuccessCode("Password Matched") />
										<cfset This.LoggedIn = 1 />
										<cfset This.UserName = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["username"] />
										<cfset This.UserID = i />
										<cfset This.Roles = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["roles"] />
										<cfset This.FullName = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["Name"] />
										<cfset This.PasswordSetTS = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["PasswordSet"] />
										<cfset This.EmailAddress = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["Email"] />
										<cfset LocalOutput = 1 />
									</cfif>
								<cfelse>
									<cfif UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["password"] EQ Arguments.password>
										<cfset SetSuccessCode("Password Matched") />
										<cfset This.LoggedIn = 1 />
										<cfset This.UserName = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["username"] />
										<cfset This.UserID = i />
										<cfset This.Roles = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["roles"] />
										<cfset This.FullName = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["Name"] />
										<cfset This.PasswordSetTS = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["PasswordSet"] />
										<cfset This.EmailAddress = UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["Email"] />
										<cfset LocalOutput = 1 />
									</cfif>
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				
				<cfset Variables.Output.LocalOutput = LocalOutput />
				
				<cfset Term(Arguments) />
			</cfsilent>	
		<cfreturn LocalOutput />
		</cffunction>
		
		<cffunction name="Logout" access="public" returntype="boolean" output="false">
			
			<cfsilent>
				<cfset Init() />
				
				<cfif IsDefined("Cookie.username")>
					<cfcookie name="username" value="" expires="now" />
				</cfif>
				
				<cfif IsDefined("Cookie.password")>
					<cfcookie name="password" value="" expires="now" />
				</cfif>
				
				<cfset InitLogin(Variables.UsersXMLLocation) />
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn 1 />
		</cffunction>	
		
		<cffunction name="SetCurrentPage" access="public" returntype="boolean" output="false">
			<cfargument name="CurrentPage" type="string" required="true" />
			
			<cfsilent>
				<cfset Init() />
				<cfset This.CurrentPage = Arguments.CurrentPage />
				<cfset Term(Arguments) />
			</cfsilent>
			
		<cfreturn 1 />
		</cffunction>
		
		<cffunction name="SetCurrentArea" access="public" returntype="boolean" output="false">
			<cfargument name="CurrentArea" type="string" required="true" />
			
			<cfsilent>
				<cfset Init() />
				<cfset This.CurrentArea = Arguments.CurrentArea />
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn 1 />
		</cffunction>
		
		<cffunction name="IsLoggedIn" access="Public" returntype="boolean" output="false">
		
			<cfset VAR LocalOutput = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif This.LoggedIn>
					<cfset LocalOutput = 1 />
				</cfif>
			
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn LocalOutput />	
		</cffunction>
		
		<cffunction name="UserInRole" access="Public" returntype="boolean" output="false">
			<cfargument name="Role" type="String" required="true" />
			
			<cfset VAR LocalOutput = 0 />
			
			<cfsilent>
				<cfset init() />
			
				<cfif ListContainsNoCase(This.Roles, Arguments.Role)>
					<cfset LocalOutput = 1 />
				</cfif>
			
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn LocalOutput />
		</cffunction>
		
		<cffunction name="Remember" access="public" returntype="boolean" output="false">
			<cfargument name="username" type="string" required="true" />
			<cfargument name="password" type="string" required="true" />
			<cfargument name="HashPassword" type="boolean" required="true" />
			
			<cfset VAR LocalOutput = 0 />
			
			<cfsilent>
				<cfset init() />
			
				<cfcookie expires="never" name="username" value="#Arguments.UserName#" />
				<cfif Arguments.HashPassword>
					<cfcookie expires="never" name="password" value="#Hash(Arguments.password)#" />
				<cfelse>
					<cfcookie expires="never" name="password" value="#Arguments.password#" />
				</cfif>
				
				<cfset LocalOutput = 1 />
				<cfset Term(Arguments) />
			</cfsilent>
			
		<cfreturn LocalOutput />
		</cffunction>
		
		<cffunction name="DoesPasswordNeedChanging" access="public" returntype="boolean" output="false">
			<cfargument name="ChangePasswordAfter" type="numeric" required="True" hint="Days" />
			
			<cfset VAR LocalOutput = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfif This.PasswordSetTS EQ "">
						<cfset LocalOutput = 1>
					<cfelseif ABS(DateDiff("d", This.PasswordSetTS, Now())) GTE Arguments.ChangePasswordAfter>
						<cfset LocalOutput = 1>
					</cfif>
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn LocalOutput />
		</cffunction>
	</cfsilent>
</cfcomponent>