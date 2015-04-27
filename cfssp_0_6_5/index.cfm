<!DOCTYPE html
PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">

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
<head>
	
	<title>SlideShowPro</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="manage/include/style.css" />
	
	<script language="VBScript">
	<!-- 
	Sub SlideShowPro_FSCommand(ByVal command, ByVal args)
	select case command
	case "putHREF" location.href = args
	case "putTitle" document.title = args
	end select
	end sub
	-->
	</script>
	<script type="text/javascript">
	<!-- 
	function flashPutHref(href) { location.href = href; }
	function flashPutTitle(title) { document.title = title; }
	-->
	</script>
	
	<!-- FlashObject embed by Geoff Stearns - http://blog.deconcept.com/2004/10/14/web-standards-compliant-javascript-flash-detect-and-embed/ -->
	<script type="text/javascript" src="flashobject.js"></script>
	
</head>

<body>
		
<div id="topbanner">
	<div id="bannercontainer">
		<div style="float:left"><h1>CF Manager for SlideShowPro</h1></div>
	</div>
</div>

<div id="container" class="clearfix">

	<div id="leftnav">
	<ul id="nav">
		<li><a href="index.cfm">SlideShow</a></li>
		<li><a href="manage/index.cfm">Manage</a></li>
		<li>&nbsp;</li>
		<li><a href="http://www.ryanguill.com/cfssp/forum/" target="_blank">Help</a></li>
	</ul>
	
	</div>
  	<div id="main">
		<div id="crumbs">
			<a href="index.cfm">SlideShowPro</a> /
		</div>
		<br />
		<br />
		<div align="center">
			<p><em>This is just an example page. You will need to publish your swf first and name it ssp.swf for this page to work.  This is just an example of how to embed the flash movie into a page, this is not intended to be seen by the public this way.  Please edit this to suit your needs</em></p>
		  <script type="text/javascript">
			// <![CDATA[
			var myFlashObject = new FlashObject("ssp.swf", "SlideShowPro", "500", "450", 7, "#666666");
			myFlashObject.addVariable("initialURL", escape(document.location));
			myFlashObject.write();
			// ]]>
			</script>
		  <p>This slideshow was developed by <a href="http://www.slideshowpro.net/" target="_blank">SlideShowPro</a> and is managed by <a href="http://www.ryanguill.com/cfssp/" target="_blank">CF Manager for SlideShowPro</a>.  <a href="http://www.ryanguill.com/cfssp/manage/" target="_blank">Click here to view the demo</a> of the SlideShow Pro CF Manager.</p>
		</div>
	</div>
	
	
	
</div>

</body>
</html>