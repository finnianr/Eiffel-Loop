note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

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
