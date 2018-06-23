note
	description: "Sets an' operand conforming to  [$source EL_PATH] in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "6"

deferred class
	EL_PATH_OPERAND_SETTER [G -> EL_PATH]

inherit
	EL_MAKE_OPERAND_SETTER [EL_PATH]
		redefine
			set_error, new_list
		end

feature {NONE} -- Implementation

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
		do
			if valid_description.has_substring ("must exist") then
				app.argument_errors.extend (argument.new_error)
				app.argument_errors.last.set_path_error (app.Eng_directory, a_value)
			else
				Precursor (a_value, valid_description)
			end
		end

	type_name: ZSTRING
		deferred
		end

end
