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
 
<!--- this code DOES NOT WORK.  Let me just repeat that for clarity, 
	THIS CODE DOES NOT WORK. Its a very good start, which i am proud of,
	but there is a whole lot more to sorting albums that meets the eye.  
	Hopefully this will be supported in future releases. 
	
	What's that?  You want to work on it?  You think you can get it working?  
	Well by all means, go right ahead.  If you succeed, let me know at 
	ryanguill@gmail.com and share.  Ill make sure it gets in the very next release.
	
	But until i get it working, i wont even support any of the code on this page.  
	There are no links to this page in the release, so its only included for others 
	to work off of if they feel so inclined.
	
	Use at your own risk.  As it is, it will puke all over your xml if you use it.
	You have been warned.--->


<!--- First test for two variables to make sure they exist
	ialbum, the index of the album you want to move
	and d, the direction you want to move it --->

<cfif NOT IsDefined("url.iAlbum") OR NOT isNumeric(url.ialbum)>
	<cflocation url="../albums/" />
</cfif>

<cfif NOT IsDefined("url.d")>
	<cflocation url="../albums/" />
</cfif>

<!--- load in the xml array of the albums --->
<cfinvoke component="#Application.Config.Paths.cfsspmapping#.cfc.SlideShow" method="GetAlbums" returnvariable="GetAlbumsRet" />

<cfif GetAlbumsRet.Done>
	<cfdump var="#GetAlbumsRet#" /><br />
	If you haven't noticed, there's problems.
	<cfabort />
</cfif>

<!--- now do a switch on d, performing the move specified --->

<cfswitch expression="#url.d#">
	<cfcase value="u">
		<!--- u means up, so you need to first make sure that the ialbum isnt equal to 1 (the first album already) --->
		<cfif url.ialbum EQ 1>
			<!--- if it is, get them out of here --->
			<cflocation url="../albums/" />
		</cfif>
		<!--- now we need to create a temp variable to hold the previous album --->
		<cfset Variables.Temp = ArrayNew(1) />
		<!--- get the index of the previous album --->
		<cfset Variables.PrAl = (Url.iAlbum - 1) />
		
		<!--- now populate the array with the information of the previous album --->
		<cfset Variables.Temp[1] = GetAlbumsRet.arAlbums[Variables.PrAl][1] /><!--- title --->
		<cfset Variables.Temp[2] = GetAlbumsRet.arAlbums[Variables.PrAl][2] /><!--- description --->
		<cfset Variables.Temp[3] = GetAlbumsRet.arAlbums[Variables.PrAl][3] /><!--- lgPath --->
		<cfset Variables.Temp[4] = GetAlbumsRet.arAlbums[Variables.PrAl][4] /><!--- tnPath --->
		<cfset Variables.Temp[5] = GetAlbumsRet.arAlbums[Variables.PrAl][5] /><!--- tn --->
		
		<!--- okay, now update the previous index with the active index's values --->
		<cfinvoke component="#Application.Config.Paths.cfsspmapping#.cfc.SlideShow" method="AlbumEdit" returnvariable="AlbumEditRet">
			<cfinvokeargument name="iAlbum" value="#Variables.PrAl#"/>
			<cfinvokeargument name="Title" value="#GetAlbumsRet.arAlbums[url.iAlbum][1]#"/>
			<cfinvokeargument name="Description" value="#GetAlbumsRet.arAlbums[url.iAlbum][2]#"/>
			<cfinvokeargument name="lgPath" value="#GetAlbumsRet.arAlbums[url.iAlbum][3]#"/>
			<cfinvokeargument name="tnPath" value="#GetAlbumsRet.arAlbums[url.iAlbum][4]#"/>
			<cfinvokeargument name="tn" value="#GetAlbumsRet.arAlbums[url.iAlbum][5]#"/>
		</cfinvoke>
		
		<!--- almost done, now just update the active index with the previous albums values which are stored in the temp var--->
		<cfinvoke component="#Application.Config.Paths.cfsspmapping#.cfc.SlideShow" method="AlbumEdit" returnvariable="AlbumEditRet">
			<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
			<cfinvokeargument name="Title" value="#Variables.Temp[1]#"/>
			<cfinvokeargument name="Description" value="#Variables.Temp[2]#"/>
			<cfinvokeargument name="lgPath" value="#Variables.Temp[3]#"/>
			<cfinvokeargument name="tnPath" value="#Variables.Temp[4]#"/>
			<cfinvokeargument name="tn" value="#Variables.Temp[5]#"/>
		</cfinvoke>
		
		<!--- now just clean up and send them back to the album list --->
		<cfset ArrayClear(Variables.Temp) />
		<cflocation url="../albums/" />
		
	</cfcase>
	<cfcase value="d">
		<!--- d means down, so you need to first make sure that the ialbum isnt equal to the number of items in the array (the last item) --->
		<cfif url.ialbum EQ ArrayLen(GetAlbumsRet.arAlbums)>
			<!--- if it is, get them out of here --->
			<cflocation url="../albums/" />
		</cfif>
		<!--- now we need to create a temp variable to hold the next album --->
		<cfset Variables.Temp = ArrayNew(1) />
		<!--- get the index of the next album --->
		<cfset Variables.NxAl = (Url.iAlbum + 1) />
		
		<!--- now populate the array with the information of the next album --->
		<cfset Variables.Temp[1] = GetAlbumsRet.arAlbums[Variables.NxAl][1] /><!--- title --->
		<cfset Variables.Temp[2] = GetAlbumsRet.arAlbums[Variables.NxAl][2] /><!--- description --->
		<cfset Variables.Temp[3] = GetAlbumsRet.arAlbums[Variables.NxAl][3] /><!--- lgPath --->
		<cfset Variables.Temp[4] = GetAlbumsRet.arAlbums[Variables.NxAl][4] /><!--- tnPath --->
		<cfset Variables.Temp[5] = GetAlbumsRet.arAlbums[Variables.NxAl][5] /><!--- tn --->
		
		<!--- okay, now update the next index with the active index's values --->
		<cfinvoke component="#Application.Config.Paths.cfsspmapping#.cfc.SlideShow" method="AlbumEdit" returnvariable="AlbumEditRet">
			<cfinvokeargument name="iAlbum" value="#Variables.NxAl#"/>
			<cfinvokeargument name="Title" value="#GetAlbumsRet.arAlbums[url.iAlbum][1]#"/>
			<cfinvokeargument name="Description" value="#GetAlbumsRet.arAlbums[url.iAlbum][2]#"/>
			<cfinvokeargument name="lgPath" value="#GetAlbumsRet.arAlbums[url.iAlbum][3]#"/>
			<cfinvokeargument name="tnPath" value="#GetAlbumsRet.arAlbums[url.iAlbum][4]#"/>
			<cfinvokeargument name="tn" value="#GetAlbumsRet.arAlbums[url.iAlbum][5]#"/>
		</cfinvoke>
		
		<!--- almost done, now just update the active index with the next albums values which are stored in the temp var--->
		<cfinvoke component="#Application.Config.Paths.cfsspmapping#.cfc.SlideShow" method="AlbumEdit" returnvariable="AlbumEditRet">
			<cfinvokeargument name="iAlbum" value="#url.iAlbum#"/>
			<cfinvokeargument name="Title" value="#Variables.Temp[1]#"/>
			<cfinvokeargument name="Description" value="#Variables.Temp[2]#"/>
			<cfinvokeargument name="lgPath" value="#Variables.Temp[3]#"/>
			<cfinvokeargument name="tnPath" value="#Variables.Temp[4]#"/>
			<cfinvokeargument name="tn" value="#Variables.Temp[5]#"/>
		</cfinvoke>
		
		<!--- now just clean up and send them back to the album list --->
		<cfset ArrayClear(Variables.Temp) />
		<cflocation url="../albums/" />
		
	</cfcase>	
	<cfdefaultcase>
		<!--- if d does not equal either d or u, then get them out of here --->
		<cflocation url="../albums/" />
	</cfdefaultcase>
</cfswitch>
