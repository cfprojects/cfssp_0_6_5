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
 
<!--- there are three url variables needed to process this page, ialbum, iImage, and d (direction).  
	Test for these and if they are missing then get them out of here --->
<cfif NOT IsDefined("url.iAlbum") OR NOT IsNumeric(url.iAlbum)>
	<cflocation url="albums.cfm" />
</cfif>

<cfif NOT IsDefined("url.iImage") OR NOT IsNumeric(url.iImage)>
	<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
</cfif>

<cfif NOT IsDefined("url.d")>
	<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
</cfif>

<!--- load in the xml arrays of the albums (maybe not necessary really) and images --->
<cfinvoke component="#Application.SlideShow#" method="GetAlbums" returnvariable="GetAlbumsRet" />

<cfif GetAlbumsRet.Done>
	<cfdump var="#GetAlbumsRet#" />
	<cfabort />
</cfif>

<cfinvoke component="#Application.SlideShow#" method="GetImages" returnvariable="GetImagesRet">
	<cfinvokeargument name="AlbumIndex" value="#url.iAlbum#"/>
</cfinvoke>
<!---
	
	On a test basis, I have added locks around all of the slideshow component calls.  
	This is to prevent corruption from multiple users, as each creation call takes
	the next index to add an image or album, and each remove changes those numbers.
	If it works as I hope it will It will be there for good.  Probably wont know this for sure
	untill after it has been out for a while and enough people have had a chance to test it. --->
<cfif GetImagesRet.Done>
	<cfdump var="#GetImagesRet#" />
	<cfabort />
</cfif>

<!--- now for the switch to handle the two possible functions, 
move up, and
move down.

If d doesnt equal either u or d, send them back to the albumview --->

<cfswitch expression="#url.d#">
	<cfcase value="u">
		<!--- first make sure that the index isnt 1 --->
		<cfif url.iImage EQ 1>
			<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
		</cfif>
		<cfset Variables.PrIn = (url.iImage - 1) /><!--- set the previous index --->
		
		<cfset Variables.Temp = ArrayNew(1) /><!--- create a temp array to hold the previous and new values --->
		<cfset Variables.Temp[1] = GetImagesRet.arImages[Variables.PrIn][1] /><!--- filename (src)--->
		<cfset Variables.Temp[2] = GetImagesRet.arImages[Variables.PrIn][2] /><!--- link --->
		<cfset Variables.Temp[3] = GetImagesRet.arImages[Variables.PrIn][3] /><!--- caption --->
		
		<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
			<cfinvoke component="#Application.SlideShow#" method="ImageEdit" returnvariable="ImageEditRet">
				<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
				<cfinvokeargument name="iImage" value="#Variables.PrIn#"/>
				<cfinvokeargument name="src" value="#GetImagesRet.arImages[url.iImage][1]#"/>
				<cfinvokeargument name="caption" value="#GetImagesRet.arImages[url.iImage][3]#"/>
				<cfinvokeargument name="link" value="#GetImagesRet.arImages[url.iImage][2]#"/>
			</cfinvoke>
		</cflock>
		
		<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
			<cfinvoke component="#Application.SlideShow#" method="ImageEdit" returnvariable="ImageEditRet">
				<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
				<cfinvokeargument name="iImage" value="#url.iImage#"/>
				<cfinvokeargument name="src" value="#Variables.Temp[1]#"/>
				<cfinvokeargument name="caption" value="#Variables.Temp[3]#"/>
				<cfinvokeargument name="link" value="#Variables.Temp[2]#"/>
			</cfinvoke>
		</cflock>
		
		<!--- just in case, get rid of the variables.temp value --->
		<cfset ArrayClear(Variables.Temp) />
		
		<!--- send them back to the album view --->
		<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
	</cfcase>
	<cfcase value="d">
		<!--- first make sure that the index isnt the last index --->
		<cfif url.iImage EQ ArrayLen(GetImagesRet.arImages)>
			<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
		</cfif>
		
		<cfset Variables.NxIn = (url.iImage + 1) /><!--- set the next index --->
		
		<cfset Variables.Temp = ArrayNew(1) /><!--- create a temp array to hold the previous and new values --->
		<cfset Variables.Temp[1] = GetImagesRet.arImages[Variables.NxIn][1] /><!--- filename (src)--->
		<cfset Variables.Temp[2] = GetImagesRet.arImages[Variables.NxIn][2] /><!--- link --->
		<cfset Variables.Temp[3] = GetImagesRet.arImages[Variables.NxIn][3] /><!--- caption --->
		
		<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
			<cfinvoke component="#Application.SlideShow#" method="ImageEdit" returnvariable="ImageEditRet">
				<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
				<cfinvokeargument name="iImage" value="#Variables.NxIn#"/>
				<cfinvokeargument name="src" value="#GetImagesRet.arImages[url.iImage][1]#"/>
				<cfinvokeargument name="caption" value="#GetImagesRet.arImages[url.iImage][3]#"/>
				<cfinvokeargument name="link" value="#GetImagesRet.arImages[url.iImage][2]#"/>
			</cfinvoke>
		</cflock>
		
		<cflock name="cfsspXmlLock" timeout="#CreateTimeSpan(0,0,3,0)#" throwontimeout="yes" type="exclusive">
			<cfinvoke component="#Application.SlideShow#" method="ImageEdit" returnvariable="ImageEditRet">
				<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
				<cfinvokeargument name="iImage" value="#url.iImage#"/>
				<cfinvokeargument name="src" value="#Variables.Temp[1]#"/>
				<cfinvokeargument name="caption" value="#Variables.Temp[3]#"/>
				<cfinvokeargument name="link" value="#Variables.Temp[2]#"/>
			</cfinvoke>
		</cflock>
		
		<!--- just in case, get rid of the variables.temp value --->
		<cfset ArrayClear(Variables.Temp) />
		
		<!--- send them back to the album view --->
		<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
	</cfcase>
	<cfdefaultcase>
		<cflocation url="albumView.cfm?iAlbum=#url.iAlbum#" />
	</cfdefaultcase>
</cfswitch>