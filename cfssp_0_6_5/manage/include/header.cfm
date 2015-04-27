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
<cfprocessingdirective suppresswhitespace = "Yes">
<div id="topbanner">
	<div id="bannercontainer">
		<div style="float:left">
			<h1>CF Manager for SlideShowPro</h1>
		</div>
		
		<div style="float:right">
			<cfoutput><span>Welcome, #Session.Login.fullname#</span><br />
			<cfif Session.Login.LoggedIn>
				<a href="logout.cfm">Logout</a>
			<cfelse>
				<a href="loginform.cfm">Login</a>
			</cfif>
			</cfoutput>
		</div>
	</div>
</div>
</cfprocessingdirective>