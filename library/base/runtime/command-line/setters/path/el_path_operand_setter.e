note
	description: "Sets an' operand conforming to  [$source EL_PATH] in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-30 10:01:04 GMT (Friday 30th October 2020)"
	revision: "12"

deferred class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH create make end]

inherit
	EL_MAKE_OPERAND_SETTER [EL_PATH]
		redefine
			set_error, new_list
		end

	EL_COMMAND_ARGUMENT_CONSTANTS

feature {NONE} -- Implementation

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

	set_error (a_value: like value; valid_description: ZSTRING)
		local
			error: EL_COMMAND_ARGUMENT_ERROR
		do
			if valid_description.has_substring ("must exist") then
				create error.make (argument.word_option)
				error.set_path_error (english_name, a_value)
				make_routine.extend_errors (error)
			else
				Precursor (a_value, valid_description)
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