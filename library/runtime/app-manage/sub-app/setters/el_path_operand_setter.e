note
	description: "Summary description for {EL_PATH_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 8:19:33 GMT (Thursday 1st June 2017)"
	revision: "1"

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
				app.set_path_argument_error (argument.word_option, app.English_directory, a_value)
			else
				Precursor (a_value, valid_description)
			end
		end

	type_name: ZSTRING
		deferred
		end

end
