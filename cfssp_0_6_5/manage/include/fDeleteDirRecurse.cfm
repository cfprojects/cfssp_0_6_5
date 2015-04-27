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
 
<cffunction name="DeleteDirRecurse" access="public" returntype="boolean" output="false">
	<cfargument name="DirAbsPath" required="True" type="string" />
		
	<cfset VAR DirExpPath = "" />
	<cfset VAR DirContents = "" />
	
	<cfsilent>
		<!--- first check to make sure that the directory exists --->
		<cfif DirectoryExists(Arguments.DirAbsPath)>
			<cfset DirExpPath = Arguments.DirAbsPath />
		<cfelse>
			<cfthrow message="Directory Doesn't Exist" />
		</cfif>
		
		<!--- get the directory contents --->
		<cfdirectory directory="#DirExpPath#" name="DirContents" action="list">
		
		<!--- loop over the contents.  If the item is a directory, call this function recursivly. --->
		<!--- <cfdump var="#DirContents#" /> --->
		
		<!--- if there is a recordcount then there are contents so  --->
		<cfif DirContents.RecordCount>
			<!--- loop through the contents and delete all files --->
			<cfloop query="DirContents">
				<cfif DirContents.Type EQ "dir">
					<!--- if a directory is found, call the function recursively --->
					<cfset DeleteDirRecurse("#DirExpPath#\#DirContents.Name#") />
				<cfelse>
					<!--- if a file is found, delete it --->
					<cftry>
						<cffile action="delete" file="#DirExpPath#\#DirContents.Name#" />
					<cfcatch>
						<cfthrow message="File #DirExpPath#\#DirContents.Name# Could Not Be Deleted" />
					</cfcatch>
					</cftry>
				</cfif>
			</cfloop>
			<!--- now that all files and directories underneath this directory is gone, delete this directory --->
			<cftry>
				<cfdirectory action="delete" directory="#DirExpPath#" />
			<cfcatch>
				<cfthrow message="Directory #DirExpPath# Could Not Be Deleted" />
			</cfcatch>
			</cftry>
		<cfelse>
			<!--- if no recordcount then there is no files or directories underneath, so delete this directory --->
			<cftry>
				<cfdirectory action="delete" directory="#DirExpPath#" />
			<cfcatch>
				<cfthrow message="Directory #DirExpPath# Could Not Be Deleted" />
			</cfcatch>
			</cftry>
		</cfif>
	</cfsilent>
<cfreturn 1 />	
</cffunction>