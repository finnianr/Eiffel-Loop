note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_CPU_INFO_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

	EL_MODULE_ENVIRONMENT

feature -- Access

	Template: STRING
			-- Mimic Unix command: cat /proc/cpuinfo
		once
			Result := "echo model name: " + Environment.Operating.Cpu_model_name
		end

end
