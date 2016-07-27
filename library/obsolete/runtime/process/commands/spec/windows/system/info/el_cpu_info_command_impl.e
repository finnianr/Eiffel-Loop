note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 15:38:13 GMT (Monday 16th May 2016)"
	revision: "3"

class
	EL_CPU_INFO_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

	EL_MODULE_ENVIRONMENT

feature -- Access

	Template: STRING
			-- Mimic Unix command: cat /proc/cpuinfo
		once
			Result := "echo model name: " + Environment.Operating.Cpu_model_name
		end

end