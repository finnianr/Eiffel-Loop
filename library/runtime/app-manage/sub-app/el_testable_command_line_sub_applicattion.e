note
	description: "Summary description for {EL_TESTABLE_UNIVERSAL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-08-15 10:39:20 GMT (Saturday 15th August 2015)"
	revision: "3"

deferred class
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [C -> EL_COMMAND create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]
		undefine
			initialize, run
		end

	EL_TESTABLE_APPLICATION

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			create command
			set_operands
			if not has_invalid_argument then
				make_command
			end
		end

	normal_run
		do
			command.execute
		end

end
