note
	description: "Summary description for {EL_COMMAND_SHELL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-22 17:19:49 GMT (Friday 22nd May 2015)"
	revision: "6"

deferred class
	EL_COMMAND_SHELL_SUB_APPLICATTION [C -> EL_COMMAND_SHELL_COMMAND create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	default_operands: TUPLE
		do
			create Result
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			create Result.make_empty
		end

end
