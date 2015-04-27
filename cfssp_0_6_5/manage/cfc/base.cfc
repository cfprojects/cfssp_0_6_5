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

<cfcomponent displayname="BaseCFC" hint="This is a Base Coldfusion Component to serve as a framework for non-persistant components. It is intended to be extended providing the constructor methods to other components." output="false">
	<cfsilent>
	<!--- Components Properties --->	
	
	
	<!--- Methods --->
		<cffunction name="Init" access="private" returntype="void" output="false" displayname="Initiation Method" 
			hint="Method to be run at the beginning of every method that creates the output structure and error and flow controls">
			
			<cfargument name="debug" required="false" default="1" type="boolean" />
			
			<cfsilent>
				<cfset Variables.Output = StructNew() />
				<cfset Variables.Done = 0 />
				<cfset Variables.Errors = 0 />
				<cfset Variables.SuccessCode = "" />
				<cfset Variables.Debug = Arguments.Debug />
				
				<cfif Variables.Debug>
					<cfset Variables.InitTime = GetTickCount() />
				</cfif>
			</cfsilent>
			
		</cffunction>
		
		<cffunction name="Term" access="private" returntype="void" output="false" displayname="Termination Method"
			hint="Method to be run right before cfreturn to return output">
			
			<cfargument name="Args" required="true" type="struct" />
			
			<cfsilent>
				<cfset Variables.Output.Done = Variables.Done />
				<cfset Variables.Output.Errors = Variables.Errors />
				<cfset Variables.Output.SuccessCode = Variables.SuccessCode />
				<cfif Variables.Done> 
					<cfset Variables.Output.Success = 0 />
				<cfelse> 
					<cfset Variables.Output.Success = 1 /> 
				</cfif> 
				
				<cfif Variables.Debug>
					<cfset Variables.Output.Args = Arguments.Args />
					<cfset Variables.Output.ExecTime = Evaluate(GetTickCount() - Variables.InitTime) />
				</cfif>
			</cfsilent>
		</cffunction>
			
		<cffunction name="SetSuccessCode" access="private" returntype="void" output="false">
			<cfargument name="SuccessCode" type="string" required="True" />
			
			<cfsilent>
				<cfset Variables.SuccessCode = ListAppend(Variables.SuccessCode, Arguments.SuccessCode) />
			</cfsilent>
		</cffunction>
		
		<cffunction name="SetDone" access="private" returntype="void" output="false">
			<cfargument name="SuccessCode" type="String" required="true" />
			
			<cfsilent>
				<cfset Variables.Done = 1 />
				<cfset Variables.Errors = 1 />
				<cfset SetSuccessCode(Arguments.SuccessCode) />
			</cfsilent>
		</cffunction>
		
		<cffunction name="SetContinue" access="Private" returntype="void" output="false">
			<cfargument name="SuccessCode" type="string" required="true" />
			
			<cfsilent>
				<cfset Variables.Done = 0 />
				<cfset SetSuccessCode(Arguments.SuccessCode) />
			</cfsilent>
		</cffunction>
	</cfsilent>
</cfcomponent>