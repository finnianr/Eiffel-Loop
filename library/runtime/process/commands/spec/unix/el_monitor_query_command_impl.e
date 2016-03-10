note
	description: "Summary description for {EL_MONITOR_QUERY_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 22:49:50 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_MONITOR_QUERY_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING_32 = "xrandr --query --screen 0"

end
