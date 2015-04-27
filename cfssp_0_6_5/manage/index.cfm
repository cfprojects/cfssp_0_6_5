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
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	
	<title>SlideShowPro CF Manager</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<cfinclude template="include/ss.cfm" />
</head>

<body>
		
<cfinclude template="include/header.cfm" />

<div id="container" class="clearfix">

	<cfinclude template="include/nav.cfm" />
	
	<cfoutput>
	<div id="main">
		<div id="crumbs">
			<a href="index.cfm">Home</a> / 
		</div>
		
		<h1>Welcome to the SlideShowPro CF Manager</h1>
		
		<p>Welcome to the SlideShowPro CF Manager!  You can perform all actions relating to your slide show here, as well as manage the users and their permissions with access to this manager. </p>
		<p>This manager was designed and developed by <a href="http://www.ryanguill.com" target="_blank">Ryan Guill</a>.</p>
		<p>Links:
			<ul>
				<li><a href="http://www.ryanguill.com/docs/" target="_blank">CFSSP Downloads</a></li>
				<li><a href="http://www.ryanguill.com/cfssp/" target="_blank">CFSSP Demo</a></li>
				<li>If you would like to help with the development of CFSSP, please <a href="mailto:ryanguill@gmail.com?subject=cfssp help">let me know</a>.</li>
				<li>If you have any questions, comments, compliments, bug reports, or suggestions please tell us all about it in the <a href="http://www.ryanguill.com/cfssp/forum/" target="_blank">CFSSP Forums.</a></li>
				<li>Please sign up for our google group at <a href="http://groups-beta.google.com/group/CFSSP" target="_blank">http://groups-beta.google.com/group/CFSSP</a>.  Signing up you will receive information about new releases, bug reports and fixes, and discuss feature requests, etc.</li>
				<li>Any time you refer to a bug, question, or suggestion, please let me know what version you are currently using.</li>
				<li>If you like this app, please consider getting me something from my <a href="http://www.amazon.com/gp/registry/registry.html/ref=cm_wl_topnav_gateway/102-6610663-5904933?type=wishlist" target="_blank">Amazon Wish List</a></li>
			</ul>
		</p>
		<cfif NOT Session.Login.LoggedIn>
			<p>You are not logged in, you must login to be able to access any part of this managment application.</p>
			<p>Please <a href="loginform.cfm">click here to login</a>
		</cfif>		
	</div>
	</cfoutput>
	
</div>

</body>
</html>