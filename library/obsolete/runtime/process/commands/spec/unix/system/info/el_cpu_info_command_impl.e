note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:19:53 GMT (Monday 16th May 2016)"
	revision: "1"

class
	EL_CPU_INFO_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	template: STRING = "cat /proc/cpuinfo"

end