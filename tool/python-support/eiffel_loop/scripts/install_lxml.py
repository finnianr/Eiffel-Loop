#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "12 Nov 2016"
#	revision: "0.0"

# DESCRIPTON

# Unfinished script to download lxml-3.6.4-cp27-cp27m-win_amd64.whl and lxml-3.6.4-cp27-cp27m-win32.whl
# from http://www.lfd.uci.edu/~gohlke/pythonlibs. 
# But this requires pip.exe to install which doesn't seem to be present in installed Python 2.7.

# Decided instead to host install files at eiffel-loop.com
# /download/libxml2-python-2.7.8.win32-py2.7.exe
# /download/libxml2-python-2.7.8.amd64-py2.7.exe

import os
from os import path
from urllib import FancyURLopener

class HTTP_CONNECTION (FancyURLopener):
	# user-agent
	version = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20100101 Firefox/17.0'

def decoded_path (javascript):
	# Decode path obfuscated with JavaScript
	# Examples:

	# 1. dl([47,108,54,110,105,50,119,99,55,100,52,112,120,45,104,51,46,103,109,101], "9;53A8C301<B1=?@2@:=7;58=7;58B=643?5@6>1")
	#    dp2ng7en/lxml-3.6.4-cp27-cp27m-win32.whl
	
	# 2. dl([108,119,100,95,104,54,112,103,45,46,109,120,55,52,101,97,99,51,110,47,105,50], "26EB7<>BC0;:08A959=8@6E<8@6E<:81DB3?:25=9140")
	#    dp2ng7en/lxml-3.6.4-cp27-cp27m-win_amd64.whl

	pos_left = javascript.find ('[')
	pos_right = javascript.find (']')
	exec ('ml =' + javascript [pos_left:pos_right + 1])

	pos_left = javascript.find ('"')
	pos_right = javascript.find ('"', pos_left + 1)
	mi = javascript [pos_left + 1 : pos_right]
	mi = mi.replace('&lt;','<')
	mi = mi.replace('&#62;','>')
	mi = mi.replace('&#38;','&')

	#print '"%s"' % mi

	chars = []
	# reverse obfuscation of package name
	for j in range (0, len (mi)):
		chars.append (chr (ml [ord (mi [j]) - 48]))

	return ('').join (chars)

def lxml_cp27_javascript (text):
	pos_lxml = text.find ('id="lxml"')
	pol_ul_close = text.find ('</ul>', pos_lxml)
	# Unresolved bug 12 Nov 2016
	# pos_lxml = -1 pol_ul_close = -1 
	
	print pos_lxml, pol_ul_close

	print text [pos_lxml:pol_ul_close]

	result = []
	for line in (text [pos_lxml:pol_ul_close]).split ('\n'):
		if 'cp27' in line:
			javascript = line [line.find (':dl') + 1 : line.find (")'") + 1]
			result.append (javascript)
			if len (result) == 2:
				break

	return result

#f = open ('workarea/pythonlibs.html', 'r')

# python test.py
#Connecting ..
#-1 -1 BUG HERE

connection = HTTP_CONNECTION ()
print 'Connecting ..'
url = "http://www.lfd.uci.edu/~gohlke/pythonlibs"
page = connection.open (url)

for js in lxml_cp27_javascript (str (page.read ())):
	print js
	print decoded_path (js)
	print 

page.close ()

