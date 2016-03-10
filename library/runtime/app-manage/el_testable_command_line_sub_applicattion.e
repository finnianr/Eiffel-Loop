note
	description: "Summary description for {EL_TESTABLE_UNIVERSAL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:19:21 GMT (Monday 17th June 2013)"
	revision: "2"

deferred class
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [C -> EL_COMMAND create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATTION [C]
		rename
			initialize as normal_initialize
		undefine
			run
		redefine
			normal_initialize
		end

	EL_TESTABLE_APPLICATION

feature {NONE} -- Initiliazation

	normal_initialize
		do
			if not is_test_mode then
				Precursor
			end
		end

	normal_run
		do
			command.execute
		end

end
