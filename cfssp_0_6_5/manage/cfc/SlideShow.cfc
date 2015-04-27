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
		
		<cffunction name="InitSlideShow" access="Public" returntype="slideshow" output="False">
			<cfargument name="sspXML" required="True" type="string" />
				<cfset Variables.sspXMl = Arguments.sspXML />
		<cfreturn This />
		</cffunction>
		
		<cffunction name="XMLRead" access="Public" returntype="struct" output="false">
			<cfset VAR XMLFile = "" />
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cftry>
						<cffile action="read" file="#ExpandPath('#Variables.sspXML#')#" variable="XMLFile" />
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
			
			<cfset VAR XMLOutput = Arguments.XMLFile />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset XMLOutput = ToString(XMLOutput) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cftry>
						<cffile action="write" file="#ExpandPath('#Variables.sspXML#')#" output="#XMLOutput#" nameconflict="overwrite" />
					<cfcatch>
						<cfset SetDone("XMLWrite Error") />
					</cfcatch>
					</cftry>
				</cfif>
			</cfsilent>
			
			<cfset Term(Arguments) />
		<cfreturn Variables.Output.success />
		</cffunction>
		
		<cffunction name="GetAlbums" access="Public" returntype="Struct" output="false">
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR arAlbums = ArrayNew(2) />
			<cfset VAR NumAlbums = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset NumAlbums = ArrayLen(XMLFile.Gallery.XMLChildren) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfif NumAlbums>
						<cfloop from="1" to="#NumAlbums#" index="iAlbums">
							<cfset arAlbums[iAlbums][1] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["Title"] />
							<cfset arAlbums[iAlbums][2] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["Description"] />
							<cfset arAlbums[iAlbums][3] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["lgpath"] />
							<cfset arAlbums[iAlbums][4] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["tnpath"] />
							<cfset arAlbums[iAlbums][5] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["tn"] />
							<!--- The number of images in this folder --->
							<cfset arAlbums[iAlbums][6] = ArrayLen(XMLFile.Gallery.XMLChildren[iAlbums].XMLChildren) />
							<!--- store the the current album index --->
							<cfset arAlbums[iAlbums][7] = iAlbums />
							
							<!--- Added 03/31/05 to support SSP version 1.0.5, but also allows support for older xml files and the transition. --->
							<!--- Set number 8 to the id, if it exists --->
							<!--- if not, then just set it to empty. --->
							<cfif structKeyExists(XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes,"id")>
								<cfset arAlbums[iAlbums][8] = XMLFile.Gallery.XMLChildren[iAlbums].XMLAttributes["id"] />
							<cfelse>
								<cfset arAlbums[iAlbums][8] = "" />
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				
				<cfif NOT Variables.Done>
					<!--- <cfset Variables.Output.XMLFile = XMLFile /> --->
					<cfset Variables.Output.arAlbums = arAlbums />
					<cfset Variables.Output.NumAlbums = NumAlbums />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="GetImages" access="Public" returntype="struct" output="false">
			<cfargument name="AlbumIndex" required="True" type="numeric" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile.Gallery.XMLChildren[Arguments.AlbumIndex] />
			<cfset VAR arImages = ArrayNew(2) />
			<cfset VAR numImages = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.done>
					<cfset numImages = ArrayLen(XMLFile.XMLChildren) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfif numImages>
						<cfloop from="1" to="#numImages#" index="iImages">
							<cfset arImages[iImages][1] = XMLFile.XMLChildren[iImages].XMLAttributes["src"] />
							<cfset arImages[iImages][2] = XMLFile.XMLChildren[iImages].XMLAttributes["link"] />
							<cfset arImages[iImages][3] = XMLFile.XMLChildren[iImages].XMLAttributes["caption"] />
							<!--- store the album index --->
							<cfset arImages[iImages][4] = Arguments.AlbumIndex />
							<!--- store the image index --->
							<cfset arImages[iImages][5] = iImages />
						</cfloop>
					</cfif>
				</cfif>
				
				<cfif NOT Variables.Done>
					<!--- <cfset Variables.Output.XMLFile = XMLFile /> --->
					<cfset Variables.Output.arImages = arImages />
					<cfset Variables.Output.numImages = numImages />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />	
		</cffunction>
		
		<cffunction name="AlbumCreate" access="Public" returntype="struct" output="false">
			<cfargument name="Title" required="True" type="string" />
			<cfargument name="Description" required="True" type="string" />
			<cfargument name="lgPath" required="True" type="string" />
			<cfargument name="tnPath" required="True" type="string" />
			<cfargument name="tn" required="True" type="string" />
			<cfargument name="AlbumXMLID" required="True" type="string" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR numAlbums = ArrayLen(XMLFile.gallery.XMLChildren) />
			<cfset VAR niAlbum = numAlbums + 1 />
			<cfset VAR XMLAlbum = "" />
			<cfset VAR XMLWriteRet = "" />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset ReplaceNoCase(Arguments.AlbumXMLID, " ", "_", "All") />
					<!--- We need to add more validation to the id to make sure special characters are not used.
						Im thinking RegEx, but open to suggestions --->
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLFile.Gallery.XMLChildren[niAlbum] = XMLElemNew(XMLFile, "album") />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["title"] = Arguments.Title />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["description"] = Arguments.Description />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["lgPath"] = Arguments.lgpath />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["tnPath"] = Arguments.tnpath />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["tn"] = Arguments.tn />
					<cfset XMLFile.Gallery.XMLChildren[niAlbum].XMLAttributes["id"] = Arguments.AlbumXMLID />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.xmlFile = xmlFile />
					<cfset Variables.Output.numAlbums = numAlbums />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="AlbumRemove" access="Public" returntype="struct" output="false">
			<cfargument name="iAlbum" required="true" type="numeric" hint="index of the album to remove" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR XMLWriteRet = "" />
			<cfset VAR numAlbums = ArrayLen(XMLFile.Gallery.XMLChildren) />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfif Arguments.iAlbum GT numAlbums>
						<cfset SetDone("Invalid Album Index") />
					</cfif>			
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset ArrayDeleteAt(XMlFile.Gallery.xmlChildren, Arguments.iAlbum) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif> 
				 
				<cfif NOT Variables.Done>
					<cfset Variables.Output.XMLFile = XMLFile />
					<cfset Variables.Output.XMLWriteRet = XMLWriteRet />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />		
		</cffunction>
		
		<cffunction name="AlbumEdit" access="Public" returntype="struct" output="false">
			<cfargument name="iAlbum" required="True" type="numeric" />
			<cfargument name="Title" required="True" type="string" />
			<cfargument name="Description" required="True" type="string" />
			<cfargument name="lgPath" required="True" type="string" />
			<cfargument name="tnPath" required="True" type="string" />
			<cfargument name="tn" required="True" type="string" />
			<cfargument name="AlbumXMLID" required="true" type="String" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR numAlbums = ArrayLen(XMLFile.gallery.XMLChildren) />
			<cfset VAR XMLAlbum = "" />
			<cfset VAR XMLWriteRet = "" />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset ReplaceNoCase(Arguments.AlbumXMLID, " ", "_", "All") />
					<!--- We need to add more validation to the id to make sure special characters are not used.
						Im thinking RegEx, but open to suggestions --->
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["title"] = Arguments.Title />
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["description"] = Arguments.Description />
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["lgPath"] = Arguments.lgpath />
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["tnPath"] = Arguments.tnpath />
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["tn"] = Arguments.tn />
					<cfset XMLFile.Gallery.XMLChildren[iAlbum].XMLAttributes["id"] = Arguments.AlbumXMLID />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.xmlFile = xmlFile />
					<cfset Variables.Output.numAlbums = numAlbums />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="ImageCreate" access="Public" returntype="struct" output="false">
			<cfargument name="iAlbum" required="True" type="numeric" hint="the index of the album you want to add the image to" />
			<cfargument name="src" required="True" type="string" />
			<cfargument name="caption" required="True" type="string" />
			<cfargument name="link" required="True" type="string" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR numImages = ArrayLen(XMLFile.gallery.XMLChildren[iAlbum].XMLChildren) />
			<cfset VAR niImage = numImages + 1 /><!--- the index of what the next image added will be --->
			<cfset VAR XMLImage = "" />
			<cfset VAR XMLWriteRet = "" />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[niImage] = XMLElemNew(XMLFile, "img") />
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[niImage].XMLAttributes["src"] = Arguments.src />
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[niImage].XMLAttributes["caption"] = Arguments.caption />
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[niImage].XMLAttributes["link"] = Arguments.link />
					
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.xmlFile = xmlFile />
					<cfset Variables.Output.numImages = numImages />
					<cfset Variables.Output.niImage = niImage />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="ImageEdit" access="Public" returntype="struct" output="false">
			<cfargument name="iAlbum" required="True" type="numeric" hint="the index of the album" />
			<cfargument name="iImage" required="True" type="numeric" hint="the index of the image" />
			<cfargument name="src" required="True" type="string" />
			<cfargument name="caption" required="True" type="string" />
			<cfargument name="link" required="True" type="string" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR numImages = ArrayLen(XMLFile.gallery.XMLChildren[iAlbum].XMLChildren) />
			<cfset VAR XMLImage = "" />
			<cfset VAR XMLWriteRet = "" />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[Arguments.iImage].XMLAttributes["src"] = Arguments.src />
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[Arguments.iImage].XMLAttributes["caption"] = Arguments.caption />
					<cfset XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren[Arguments.iImage].XMLAttributes["link"] = Arguments.link />
					
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset Variables.Output.xmlFile = xmlFile />
					<cfset Variables.Output.numImages = numImages />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />
		</cffunction>
		
		<cffunction name="ImageRemove" access="Public" returntype="struct" output="false">
			<cfargument name="iAlbum" required="true" type="numeric" hint="index of the album that contains the image to remove" />
			<cfargument name="iImage" required="true" type="numeric" hint="index of the image to remove" />
			
			<cfset VAR XMLFile = XMLRead().XMLFile />
			<cfset VAR XMLWriteRet = "" />
			<cfset VAR numAlbums = ArrayLen(XMLFile.Gallery.XMLChildren) />
			<cfset VAR numImages = 0 />
			
			<cfsilent>
				<cfset Init() />
				
				<cfif NOT Variables.Done>
					<cfif Arguments.iAlbum GT numAlbums>
						<cfset SetDone("Invalid Album Index") />
					</cfif>			
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset numImages = ArrayLen(XMLFile.Gallery.XMLChildren[Arguments.iAlbum].XMLChildren) />
					<cfif Arguments.iImage GT numImages>
						<cfset SetDone("Invalid Image Index") />
					</cfif>
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset ArrayDeleteAt(XMlFile.Gallery.xmlChildren[Arguments.ialbum].xmlchildren, Arguments.iImage) />
				</cfif>
				
				<cfif NOT Variables.Done>
					<cfset XMLWriteRet = XMLWrite(XMLFile) />
				</cfif> 
				 
				<cfif NOT Variables.Done>
					<cfset Variables.Output.XMLFile = XMLFile />
					<cfset Variables.Output.XMLWriteRet = XMLWriteRet />
				</cfif>
				
				<cfset Term(Arguments) />
			</cfsilent>
		<cfreturn Variables.Output />		
		</cffunction>
	</cfsilent>	
</cfcomponent>