note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:19:11 GMT (Wednesday 24th July 2013)"
	revision: "3"

class
	EL_COMMAND_LINE_ARGUMENTS

inherit
	ARGUMENTS_32

	EL_MODULE_STRING

feature -- Access

	word_option_argument (a_word_option: EL_ASTRING): EL_ASTRING
			-- Value of argument preceded by word option
			-- Result is empty if none
		local
			index: INTEGER
		do
			create Result.make_empty
			if word_option_exists (a_word_option.to_unicode) then
				index := index_of_word_option (a_word_option.to_unicode) + 1
				if index <= argument_count then
					Result := argument_latin (index)
				end
			end
		end

	remaining (index: INTEGER): ARRAYED_LIST [EL_ASTRING]
		require
			valid_index: index <= argument_count
		local
			i: INTEGER
		do
			create Result.make (argument_count - index + 1)
			from i := index until i > argument_count loop
				Result.extend (argument_latin (i))
				i := i + 1
			end
		end

	remaining_file_paths (index: INTEGER): ARRAYED_LIST [EL_FILE_PATH]
		require
			valid_index: index <= argument_count
		do
			create Result.make (argument_count - index + 1)
			across remaining (index) as l_arg loop
				Result.extend (l_arg.item)
			end
		end

	argument_latin (i: INTEGER): EL_ASTRING
		do
			create Result.make_from_unicode (argument (i))
		end

feature -- Basic operations

	set_string_from_word_option (
		word_option: EL_ASTRING; string_setter: PROCEDURE [ANY, TUPLE [EL_ASTRING]]; default_value: EL_ASTRING
	)
			--
		do
			if argument_exists (word_option) then
				string_setter.call ([argument_latin (index_of_word_option (word_option.to_unicode) + 1)])
			else
				string_setter.call ([default_value])
			end
		end

	set_real_from_word_option (
		word_option: EL_ASTRING; value_setter: PROCEDURE [ANY, TUPLE [REAL]]; default_value: REAL
	)
			--
		local
			real_string: EL_ASTRING
		do
			if argument_exists (word_option) then
				real_string := argument_latin (index_of_word_option (word_option.to_unicode) + 1)
				if real_string.is_real then
					value_setter.call ([real_string.to_real])
				end
			else
				value_setter.call ([default_value])
			end
		end

	set_integer_from_word_option (
		word_option: EL_ASTRING; value_setter: PROCEDURE [ANY, TUPLE [INTEGER]]; default_value: INTEGER
	)
			--
		local
			integer_string: EL_ASTRING
		do
			if argument_exists (word_option.to_unicode) then
				integer_string := argument_latin (index_of_word_option (word_option) + 1)
				if integer_string.is_integer then
					value_setter.call ([integer_string.to_integer])
				end
			else
				value_setter.call ([default_value])
			end
		end

	set_boolean_from_word_option (
		word_option: EL_ASTRING; value_setter: PROCEDURE [ANY, TUPLE]
	)
			--
		do
			if word_option_exists (word_option) then
				value_setter.call ([])
			end
		end

feature -- Status query

	argument_exists (word_option: EL_ASTRING): BOOLEAN
			--
		do
			Result := index_of_word_option (word_option.to_unicode) > 0
							and then (index_of_word_option (word_option.to_unicode) + 1) <= argument_count
		end

	word_option_exists (word_option: EL_ASTRING): BOOLEAN
			--
		do
			Result := index_of_word_option (word_option.to_unicode) > 0
		end

end