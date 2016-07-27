note
	description: "Summary description for {EL_GRAPHICS_INFO_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 15:38:28 GMT (Monday 16th May 2016)"
	revision: "3"

class
	EL_GRAPHICS_INFO_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	template: STRING = "xrandr --query --screen 0"

end