note
	description: "Sets an' operand conforming to  ${EL_PATH} in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 15:02:49 GMT (Monday 22nd April 2024)"
	revision: "20"

class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH create make_expanded end]

inherit
	EL_MAKE_OPERAND_SETTER [EL_PATH]
		redefine
			default_argument_setter, new_list, value
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

	new_list (string_value: ZSTRING): EL_ZSTRING_LIST
		do
			if is_bag then
				Result := Args.remaining_items (argument.word_option)
			else
				Result := Precursor (string_value)
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