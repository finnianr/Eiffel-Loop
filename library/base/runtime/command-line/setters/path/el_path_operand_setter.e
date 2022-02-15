note
	description: "Sets an' operand conforming to  [$source EL_PATH] in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 14:00:13 GMT (Tuesday 15th February 2022)"
	revision: "14"

deferred class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH create make end]

inherit
	EL_MAKE_OPERAND_SETTER [EL_PATH]
		redefine
			default_argument_setter, new_list
		end

	EL_COMMAND_ARGUMENT_CONSTANTS

feature {NONE} -- Implementation

	default_argument_setter (a_value: like value; a_description: ZSTRING): PROCEDURE [EL_COMMAND_ARGUMENT_ERROR]
		do
			if a_description.has_substring ("must exist") then
				Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_path_error (english_name, a_value)
			else
				Result := agent {EL_COMMAND_ARGUMENT_ERROR}.set_invalid_argument (a_description)
			end
		end

	english_name: ZSTRING
		deferred
		end

	new_list (string_value: ZSTRING): EL_ZSTRING_LIST
		do
			if is_list then
				Result := Args.remaining_items (argument.word_option)
			else
				Result := Precursor (string_value)
			end
		end

feature {NONE} -- Implementation

	value (str: ZSTRING): G
		do
			create Result.make (str)
			-- `ARGUMENTS_32' only expands `$' arguments in workbench mode
			-- So for finalized exe we need this line
			Result.expand
		end
end