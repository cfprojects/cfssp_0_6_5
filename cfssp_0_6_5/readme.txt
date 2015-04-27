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

  http://www.gnu.org/copyleft/gpl.html
************************************************************************/

# ColdFusion Manager for SlideShowPro
# Version 0.6.5
# December 27, 2005
# Ryan Guill
# http://www.ryanguill.com/
# ryanguill@gmail.com

# Project Home: http://www.ryanguill.com/docs/
# Demo: http://www.ryanguill.com/cfssp/
# Forums: (currently down, use the mailing list below )http://www.ryanguill.com/cfssp/forum/
# Mailing List / Google Group http://groups-beta.google.com/group/CFSSP - Sign up for the group to get emails when new versions are ready and bug reports are discovered.

# System Requirements:
# ColdFusion MX 6.1 or higher - http://www.macromedia.com/software/coldfusion/
# A Webserver.  IIS, Apache, or the like.  (note: CFSSP has only been tested on IIS, although there is no reason to beleive that it wouldn't work on any webserver.  I will only attempt to support IIS though.)
# Todd Dominey's SlideShowPro - http://www.slideshowpro.net
# CFSSP, newest version. - http://www.ryanguill.com/docs/

# Installation Instructions
# (If you are upgrading from 0.4 or higher, skip to the upgrade instructions for 0.4)
# (If you are upgrading from 0.3 or below, skip to the upgrade instructions for 0.1-0.3)

# Note: These Installation Instructions assume you have at least some knowledge of html, file structures and how to use zip files. It also assumes you already have your webserver (IIS, Apache or the like) already installed and running, as well as ColdFusion.  For help with those installations, please refer to the products help documentation.
# Download the zip or rar file to your machine. (http://www.ryanguill.com/docs/)
# Extract the contents into the directory that you choose for your slideshow in your webroot.
# Your folder structure should be set up as such:
	*webroot
		(slideshowdir)
			+config
			+gallery
			+manage
			+index.xxx (.cfm, .htm, .html, .php, this is the file that will display the flash slideshow, whatever you choose)
			+ssp.xml
			+ssp.swf (this is the file that you will publish to this directory from the flash movie.)
# Where (slideshowdir) is the directory you chose to extract the contents into and where you want your slideshow to be displayed.
# It is importaint that the ssp.xml, the gallery folder and the manage folder all be on the same level (in the same directory). 
# It is also importaint that you do not change any location of files inside the manage folder.
# Download Massimos tmt_img.cfc from http://www.olimpo.ch/tmt/cfc/tmt_img/.  Open the zip file and extract the tmt_img.cfc into /manage/cfc/ and then rename it to img.cfc
# Publish your slideshowpro swf to the (slideshowdir) that you chose as show above.  I suggest naming it ssp.swf, either way, you will need to embed it in the page where you want the actual slide show to show up.  If you publish it to the main directory and name it ssp.swf you should be able to use the provided index.cfm for testing.  Note: this page is included for example purposes only, and should be changed before viewable to the public.
# You should publish your swf with the xml location in the properties of just "ssp.xml" if you publish it in the same directory (recomended).
# You should now be ready to go.  You should be able to go to http://(website)/(slideshowdir)/manage/ and see the home page for the manage app with the login link.
# You can log in with the username "admin" and the password "password" the first time.  This admin user has GlobalAdmin roles, meaning loggin in with this username and password you can do everything.  You will want to go to users and immediately add yourself as a user, then log out and log in as yourself and remove the admin user for security reasons.
# Now you should be able to start creating your albums and putting images in them. If you add images and they dont imediately show up in the slide show when you view it, clear the cache in your browser and refresh. Most browsers cache the swf so you will need to change it before it will load correctly.
# If you have any problems, feel free to contact me at ryanguill@gmail.com.  Please let me know the exact nature of your problem and what version of cfssp you are using.  Also, if possible, please try to post problems and all other comments, suggestions and requests to the forums (http://www.ryanguill.com/cfssp/forum/) so everyone can benefit from the conversation.



# Upgrade Instructions from version 0.4 or higher
# If you are upgrading from version 0.4 then this is quite easy for you.
# Download the zip or rar file to your machine. (http://www.ryanguill.com/docs/)
# Extract the manage folder out of the zip or rar archive and overwrite the existing manage folder.
# Go to http://(website)/(slideshowdir)/manage/index.cfm?reinit
# You're ready to go.


# Upgrade Instructions from version 0.3 or lower
# If you are using version 0.3 and below things are a bit more complicated.
# You unforutunately are going to have to start over on your gallery, or go through and edit all of the xml file. Basically you need to have all the paths point to gallery/... not /gallery/... or anything/gallery/...
# Backup your users.xml file. This is now in a new place with version 0.4+.
# Remove all of the previous files. Then follow the instructions from above as if you are doing a brand new installation. When done, go to the next instruction.
# Now you can take your users.xml file and drop it into the new config folder and overwrite the one in there.
# You should be ready to go.

# Other points of interest.

# New in version 0.6.5
# Removed the img.cfc from the download, you must download it seperately and install.
# Removed the need for the JAI (Java Advanced Imaging) library

# New in version 0.6.0:
# Added GPL license to download.
# Added Comment at the top of every file.

# Changed files for version 0.6.0 (since 0.5.0)
# All files - Comment added to the top of every file.  Does not affect performance.
# Added: /gpl.txt

# New in version 0.5.0:
# Added support for the id="" value in the Album node in the ssp.xml.  This also supports backwards compatability with older xml files without the id="" attribute.

# Changed files for version 0.5.0 (since 0.4.6):
# /ssp.xml (not directly, but will be changed with the new code)
# /manage/cfc/slideshow.cfc
# /manage/albumsaction.cfm
# /manage/albums.cfm
# /manage/albumEdit.cfm
# /manage/users.cfm
# /manage/include/style.cfm
# /readme.txt
# Added: /flashobject.js (for permalink support, more info: http://blog.deconcept.com/2005/03/31/proper-flash-embedding-flashobject-best-practices/)
# /index.cfm


# New in version 0.4.6:
# Cleaned up a lot of the markup.
# Removed all icons in the manage.  If you still have a /manage/img/ folder you can now remove it.  It will not be used in future releases (as far as I know ;))
# Added the ability to remove Albums and its corresponding Folder and contents.
# Add the check when removing users and albums.
# SEVERAL bug fixes.
# Added version info to the sidebar.  Please use this version info anytime you contact me either through email or forums.  If you don't it will be the first question I ask.
# Added support for AllowRemember.  You can now change the value in your AppConfig.xml file to 1 and a box will appear in the login form asking if you want the app to remember your username and password saving you from having to log in every time and from session timeouts.
# Help files are gone.  They will probably re-appear towards the 1.0 release, but they got out of date very quickly and I just don't have the time to keep them up.  If there is something that isn't apparent to you about how to do something, just ask in the forums.
# A few other minor changes, most of which I can't remember.

# As always, please let me know if you have any problems, questions or suggestions.  I especially want to hear about things that I could do to make cfssp better.  This app is open source for a reason, and if anyone wants to help with it please let me know.  But I want this to be the answer to all your slideshowpro management needs, so if there is something you wish that it did/didn't do/did differently, please feel free to put it out there.  And as always, if you really do enjoy this app, consider getting me something from my Amazon Wish List: http://www.amazon.com/gp/registry/registry.html/ref=cm_wl_topnav_gateway/102-6610663-5904933?type=wishlist ;)

Thanks, and starting next time you will also see a changed files list.