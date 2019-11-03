note
	description: "Sets an' operand conforming to  [$source EL_PATH] in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-15 9:19:36 GMT (Sunday 15th September 2019)"
	revision: "10"

deferred class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH]

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
		local
			option_index, i: INTEGER
		do
			if is_list then
				option_index := Args.index_of_word_option (argument.word_option)
				create Result.make (Args.argument_count - option_index)
				Result.extend (string_value)
				-- Add remaining arguments
				from i := option_index + 2 until i > Args.argument_count loop
					Result.extend (Args.item (i))
					i := i + 1
				end
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

end
