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
 
<div id="leftnav">
	<cfoutput>
		<ul id="nav">
			<li><a href="index.cfm">Home</a></li>
			<cfif Session.Login.LoggedIn>
				<cfif Session.login.UserInRole("UAdd") 
					OR Session.Login.UserInRole("UEdit") 
					OR Session.Login.UserInRole("URemove") 
					OR Session.Login.UserInRole("GlobalAdmin")>
					<li><a href="users.cfm">Users</a></li>
				</cfif>
				<cfif Session.login.UserInRole("ACreate") 
					OR Session.Login.UserInRole("AEdit") 
					OR Session.Login.UserInRole("ARemove") 
					OR Session.Login.UserInRole("IAdd")
					OR Session.Login.UserInRole("IEdit") 
					OR Session.Login.UserInRole("IRemove") 
					OR Session.Login.UserInRole("GlobalAdmin")>
					<li><a href="albums.cfm">Albums</a></li>
				</cfif>
				<li>&nbsp;</li>
				<li><a href="../index.cfm">View SlideShow</a> <a href="../index.cfm" target="_blank">(new window)</a></li>
				<li>&nbsp;</li>
				<li><a href="logout.cfm">Logout</a></li>
			<cfelse>
				<li><a href="loginform.cfm">Login</a></li>
			</cfif>
			<li>&nbsp;</li>
			<li><a href="http://www.ryanguill.com/cfssp/" target="_blank">CFSSP Home</a></li>
			<li><a href="http://www.ryanguill.com/cfssp/forum/" target="_blank">Help</a></li>
			<li>&nbsp;</li>
			<li><abbr title="ColdFusion Manager For SlideShowPro Version 0.5 BETA">CFSSP v0.6.5</abbr></li>
		</ul>
	</cfoutput>
</div>