note
	description: "Summary description for {EL_MONITOR_QUERY_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_MONITOR_QUERY_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING = "xrandr --query --screen 0"

end
