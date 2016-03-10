note
	description: "[
		Unix installer for GNOME desktop. Creates Nautilus script program launcher.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

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
