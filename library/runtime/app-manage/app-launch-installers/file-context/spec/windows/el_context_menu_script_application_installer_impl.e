note
	description: "[
		Unix installer for GNOME desktop. Creates Nautilus script program launcher.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 16:03:05 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMPL

inherit
	EL_PLATFORM_IMPL

feature {EL_APPLICATION_INSTALLER} -- Constants

	Launch_script_location: STRING = ""

	Launch_script_template: STRING =
		-- Substitution template

	"[
	]"


end
