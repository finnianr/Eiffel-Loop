note
	description: "Summary description for {EL_COMMAND_SHELL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:19:44 GMT (Monday 29th May 2017)"
	revision: "2"

deferred class
	EL_COMMAND_SHELL_SUB_APPLICATTION [C -> EL_COMMAND_SHELL_COMMAND create default_create end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	default_operands: TUPLE
		do
			create Result
		end

	argument_specs: ARRAY [like specs.item]
		do
			create Result.make_empty
		end

end
