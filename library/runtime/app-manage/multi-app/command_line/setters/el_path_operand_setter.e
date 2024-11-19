note
	description: "Sets an' operand conforming to  ${EL_PATH} in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-19 9:52:28 GMT (Tuesday 19th November 2024)"
	revision: "23"

class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH create make_expanded end]

inherit
	EL_MAKE_OPERAND_SETTER [EL_PATH]
		redefine
			default_argument_setter, value
		end

feature {NONE} -- Implementation

	default_argument_setter (a_value: like value; a_description: ZSTRING): PROCEDURE [EL_COMMAND_ARGUMENT_ERROR]
		do
			if a_description.has_substring ("must exist") then
				Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_path_error (a_value)
			else
				Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_invalid_argument (a_description)
			end
		end

feature {NONE} -- Implementation

	value (str: ZSTRING): G
		do
			create Result.make_expanded (str)
			-- `ARGUMENTS_32' only expands `$' arguments in workbench mode
			-- So for finalized exe we need this line
		end
end