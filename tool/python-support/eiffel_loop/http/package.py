#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

from remote_archive import *

from eiffel_loop.xml.xpath import XPATH_CONTEXT
from string import Template

def http_gnome_url (package_http, platform):
	package_ctx = XPATH_CONTEXT (package_http)
	url_count = package_ctx.int_value ('count (//package/url)')
	if url_count == 1:
		xpath = '/package/url'
	else:
		xpath = "/package/url[@platform='%s']" % platform
		
	result = package_ctx.text (xpath)
	if url_count == 1:
		template = Template (result)
		result = template.substitute (PLATFORM = platform)
	return result

def http_debian_url (package_path, platform):
	package_ctx = XPATH_CONTEXT (package_path)
	template = Template (package_ctx.text ('/debian-package/url'))
	result = template.substitute (PLATFORM = platform)
	return result

def install_package_from_http_sources (target, source, env, install, http_url, convert_ise_platform):
	download_dir = path.join (env ['EIFFEL_LOOP'], 'Downloads')
#	download_dir = path.join (shortest_dirname (source), 'Downloads')
	platform_name = convert_ise_platform (env ['ISE_PLATFORM'])

	# Scons builder action to install targets from sources
	packages = {}
	for i in range (0, len (source)):
		url = http_url (str (source [i]), platform_name)
		member_name = str (target [i])
		print 'member_name', member_name
		if url in packages:
			members = packages [url]
			members.append (member_name)
		else:
			packages [url] = [member_name]
			
	for url in packages:
		install (download_dir, url, packages [url])

def install_gnome_zip_from_http_sources (target, source, env):
	install_package_from_http_sources (target, source, env, zip_install, http_gnome_url, gnome_org_platform)

def install_debian_from_http_sources (target, source, env):
	install_package_from_http_sources (target, source, env, debian_install, http_debian_url, debian_platform)
   
