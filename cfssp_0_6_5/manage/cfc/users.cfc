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
<cfcomponent extends="base" output="true">
	<cfsilent>
		<!--- Component Properties --->
		<!--- <cfset Variables.UsersXMLLocation = "/cfssp/manage/config/users.xml" /> --->
		
		<cffunction name="InitUsers" access="Public" reuturntype="users" output="False">
			<cfargument name="UsersXMLLocation" required="True" type="String" />
			<cfset Variables.UsersXMLLocation = Arguments.UsersXMLLocation />
		<cfreturn This />
		</cffunction>
		
		<!--- Component Methods --->
		<cffunction name="ReadUsersXML" access="public" output="false" returntype="string">
			
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
							<cfset SetDone("ReadUsersXML Failed") />
						</cfcatch>
						</cftry>
					</cflock>
				</cfif>
				
				<cfif NOT Variables.Done>
					<cftry>
						<cfset Output = XMLParse(Output) />
					<cfcatch>
						<cfset SetDone("ReadUsersXML Parse Failed") />
					</cfcatch>
					</cftry>
				</cfif>
				
				<!--- run the term method --->
				<cfset Term(arguments) />
			</cfsilent>
		<cfreturn Output />
		</cffunction>
		
		<cffunction name="WriteUsersXML" access="public" output="false" returntype="struct">
			<cfargument name="XMLFile" required="true" type="string" />
			
			<cfset VAR Output = ToString(Arguments.XMLFile) />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cflock type="exclusive" name="UsersXML" timeout="#CreateTimeSpan(0,0,2,0)#">
						<cftry>
							<cffile action="Write" file="#ExpandPath(Variables.UsersXMLLocation)#" output="#Output#" />
						<cfcatch>
							<cfset SetDone("WriteUsersXML Failed") />
						</cfcatch>
						</cftry>
					</cflock>
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		
		
		<cffunction name="UserCreate" access="Public" output="false" returntype="struct">
			<cfargument name="Name" required="true" type="String" />
			<cfargument name="Email" required="true" type="String" />
			<cfargument name="Username" required="true" type="string" />
			<cfargument name="Password" required="true" type="string" />
			<cfargument name="HashPassword" required="true" type="boolean" />
			<cfargument name="Roles" required="True" type="string" />
			
			<cfset VAR UsersXML = ReadUsersXML() />
			<cfset VAR numUsers = ArrayLen(UsersXML.AdminUsers.XMLChildren) />
			<cfset VAR niUser = (numUsers + 1) />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset UsersXML.AdminUsers.XMLChildren[niUser] = XMLElemNew(UsersXML, "user") />
					<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["name"] = Arguments.Name />
					<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["email"] = Arguments.email />
					<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["username"] = Arguments.username />
					
					<cfif Arguments.HashPassword>
						<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["password"] = Hash(Arguments.password) />
					<cfelse>
						<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["password"] = Arguments.password />
					</cfif>
					
					<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["roles"] = Arguments.roles />
					<cfset UsersXML.AdminUsers.XMLChildren[niUser].XMLAttributes["passwordset"] = Now() />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset WriteUsersXML(UsersXML) />
				</cfif>
				
				<!--- The following sets are for debuging purposes, they will dissapear in the 1.0 release --->
				<!--- <cfset Variables.Output.UsersXML = UsersXML /> --->
				<cfset Variables.Output.numUsers = NumUsers />
				<cfset Variables.Output.niUser = niUser />
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="UserCheck" access="Public" output="false" returntype="struct" hint="returns result = true if this username or email is found, false if not">
			<cfargument name="Email" required="true" type="String" />
			<cfargument name="Username" required="true" type="string" />
			
			<cfset VAR UsersXML = ReadUsersXML() />
			<cfset VAR numUsers = ArrayLen(UsersXML.AdminUsers.XMLChildren) />
			<cfset VAR Result = 0 />
			<cfset VAR iUser = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfif numUsers>
						<cfloop from="1" to="#NumUsers#" index="i">
							<cfif UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["email"] EQ Arguments.Email>
								<cfset Result = 1 />
								<cfset iUser = i />
							</cfif>
							<cfif UsersXML.AdminUsers.XMLChildren[i].XMLAttributes["username"] EQ Arguments.username>
								<cfset Result = 1 />
								<cfset iUser = i />
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				
				<cfset Variables.Output.Result = Result />
				<cfset Variables.Output.iUser = iUser />
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="UserEdit" access="Public" output="false" returntype="struct">
			<cfargument name="iUser" required="true" type="numeric" />
			<cfargument name="Name" required="true" type="String" />
			<cfargument name="Email" required="true" type="String" />
			<cfargument name="Username" required="true" type="string" />
			<cfargument name="Roles" required="True" type="string" />
			
			<cfset VAR UsersXML = ReadUsersXML() />
			<cfset VAR numUsers = ArrayLen(UsersXML.AdminUsers.XMLChildren) />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset UsersXML.AdminUsers.XMLChildren[Arguments.iUser].XMLAttributes["name"] = Arguments.Name />
					<cfset UsersXML.AdminUsers.XMLChildren[Arguments.iUser].XMLAttributes["email"] = Arguments.email />
					<cfset UsersXML.AdminUsers.XMLChildren[Arguments.iUser].XMLAttributes["username"] = Arguments.username />
					<cfset UsersXML.AdminUsers.XMLChildren[Arguments.iUser].XMLAttributes["roles"] = Arguments.roles />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset WriteUsersXML(UsersXML) />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />	
		</cffunction>
		
		<cffunction name="UserRemove" access="Public" output="false" returntype="struct">
			<cfargument name="iUser" required="true" type="numeric" />
			
			<cfset VAR UsersXML = ReadUsersXML() />
			<cfset VAR numUsers = ArrayLen(UsersXML.AdminUsers.XMLChildren) />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset ArrayDeleteAt(UsersXML.AdminUsers.XMLChildren, Arguments.iUser) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset WriteUsersXML(UsersXML) />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />	
		</cffunction>
	</cfsilent>	
</cfcomponent>