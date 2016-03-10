note
	description: "Summary description for {EL_COMMAND_SHELL_SUB_APPLICATTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
