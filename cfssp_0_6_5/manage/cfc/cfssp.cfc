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
		
		<cffunction name="InitCFSSP" access="public" returntype="cfssp" output="false">
			<cfargument name="ConfigFilePath" required="True" type="String" />
			<cfset Variables.ConfigFilePath = Arguments.ConfigFilePath />
		<cfreturn This />
		</cffunction>
		
		<cffunction name="XMLRead" access="Public" returntype="struct" output="false">
			
			<cfset VAR XMLFile = "" />
			
			<cfsilent>
				<cfset Init() />
					
				<cfif NOT Variables.Done>
					<cftry>
						<cffile action="read" file="#ExpandPath('#Variables.ConfigFilePath#')#" variable="XMLFile" />
					<cfcatch>
						<cfset SetDone("ReadXML Error") />
					</cfcatch>
					</cftry>
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLFile = XMLParse(XMLFile) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.XMLFile = XMLFile />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="XMLWrite" access="Public" returntype="boolean" output="false">
			<cfargument name="XMLFile" required="True" type="string" hint="xmlobject to be converted to string and written to file" />
			
			<cfset VAR XMLOutput = ToString(Arguments.XMLFile) />
			
			<cfsilent>
				<cfset Init() />
			
				<cfif NOT Variables.Done>
					<cftry>
						<cffile action="write" file="#ExpandPath('#Variables.configFilePath#')#" output="#XMLOutput#" nameconflict="overwite" />
					<cfcatch>
						<cfset SetDone("XMLWrite Error") />
					</cfcatch>
					</cftry>
				</cfif>
			
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output.success />
		</cffunction>
		
		<cffunction name="EditConfig" access="Public" returntype="struct" output="false">
			<cfargument name="UsersHashPasswords" required="true" type="boolean" />
			<cfargument name="LoginAllowRemember" required="True" type="boolean" />
			<cfargument name="ImageSizesAlbumTNWidth" required="True" type="numeric" />
			<cfargument name="ImageSizesImageTNWidth" required="True" type="numeric" />
			<cfargument name="ImageSizesImageFullWidth" required="True" type="numeric" />
			
			<cfset VAR ConfigXML = XMLRead() />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset ConfigXML = ConfigXML.XMlFile />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset ConfigXML.config.settings.users.hashpasswords.XMLText = Arguments.UsersHashPasswords />
					
					<cfset ConfigXML.config.settings.login.allowremember.XMLText = Arguments.LoginAllowRemember />
										
					<cfset ConfigXML.config.settings.imagesizes.albumthumbnailwidth.XMLText = Arguments.ImageSizesAlbumTNWidth />
					<cfset ConfigXML.config.settings.imagesizes.imagethumbnailwidth.XMLText = Arguments.ImageSizesImageTNWidth />
					<cfset ConfigXML.config.settings.imagesizes.imagefullwidth.XMLText = Arguments.ImageSizesImageFullWidth />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWrite(ConfigXML) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.ConfigXML = ConfigXML />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="LoadAppConfig" access="public" returntype="struct" output="false">
			<cfset VAR ConfigXML = XMLRead().XMlFile />
			
			<cfsilent>
				<cfset Init() />				
				
				<cfif NOT Variables.Done>
					<cfif IsDefined("Application.Config")>
						<cfset StructClear(Application.Config) />
					<cfelse>
						<cfset Application.Config = StructNew() />
					</cfif>
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Application.Config.Users.HashPasswords = ConfigXML.config.settings.users.hashpasswords.XMLText />
					
					<cfset Application.Config.Login.AllowRemember = ConfigXML.config.settings.login.allowremember.XMLText />
					
					<cfset Application.Config.ImageSizes.AlbumTNWidth = ConfigXML.config.settings.imagesizes.albumthumbnailwidth.XMLText />
					<cfset Application.Config.ImageSizes.ImageTNWidth = ConfigXML.config.settings.imagesizes.imagethumbnailwidth.XMLText />
					<cfset Application.Config.ImageSizes.ImageFullWidth = ConfigXML.config.settings.imagesizes.imagefullwidth.XMLText />
					
					<cfset Application.ConfigLoaded = 1 />	
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />	
		</cffunction>
	</cfsilent>
</cfcomponent>