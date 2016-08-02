note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:04:27 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_COMMAND_LINE_ARGUMENTS

inherit
	ARGUMENTS_32

feature -- Access

	remaining_items (index: INTEGER): ARRAYED_LIST [ZSTRING]
		require
			valid_index: index <= argument_count
		local
			i: INTEGER
		do
			create Result.make (argument_count - index + 1)
			from i := index until i > argument_count loop
				Result.extend (item (i))
				i := i + 1
			end
		end

	remaining_file_paths (index: INTEGER): ARRAYED_LIST [EL_FILE_PATH]
		require
			valid_index: index <= argument_count
		local
			l_remaining_items: like remaining_items
		do
			l_remaining_items := remaining_items (index)
			create Result.make (l_remaining_items.count)
			across l_remaining_items as string loop
				Result.extend (string.item)
			end
		end

	item (i: INTEGER): ZSTRING
		require
			item_exists: 1 <= i and i <= argument_count
		do
			create Result.make_from_unicode (argument (i))
		end

	directory_path (name: ZSTRING): EL_DIR_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	file_path (name: ZSTRING): EL_FILE_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	integer (name: ZSTRING): INTEGER
		require
			integer_value_exists: has_integer (name)
		do
			Result := value (name).to_integer
		end

	option_name (index: INTEGER): ZSTRING
		do
			if argument_array.valid_index (index) then
				Result := item (index)
				Result.prune_all_leading ('-')
			else
				create Result.make_empty
			end
		end

	value (name: ZSTRING): ZSTRING
			-- string value of name value pair arguments
		require
			has_value: has_value (name)
		local
			index: INTEGER
		do
			index := index_of_word_option (name.to_unicode) + 1
			if index >= 2 and index <= argument_count then
				Result := item (index)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	set_string_from_word_option (
		word_option: ZSTRING; set_string: PROCEDURE [ANY, TUPLE [ZSTRING]]; default_value: ZSTRING
	)
			--
		do
			if has_value (word_option) then
				set_string (item (index_of_word_option (word_option.to_unicode) + 1))
			else
				set_string (default_value)
			end
		end

	set_real_from_word_option (
		word_option: ZSTRING; set_real: PROCEDURE [ANY, TUPLE [REAL]]; default_value: REAL
	)
			--
		local
			real_string: ZSTRING
		do
			if has_value (word_option) then
				real_string := item (index_of_word_option (word_option.to_unicode) + 1)
				if real_string.is_real then
					set_real (real_string.to_real)
				end
			else
				set_real (default_value)
			end
		end

	set_integer_from_word_option (
		word_option: ZSTRING; set_integer: PROCEDURE [ANY, TUPLE [INTEGER]]; default_value: INTEGER
	)
			--
		local
			integer_string: ZSTRING
		do
			if has_value (word_option) then
				integer_string := item (index_of_word_option (word_option) + 1)
				if integer_string.is_integer then
					set_integer (integer_string.to_integer)
				end
			else
				set_integer (default_value)
			end
		end

	set_boolean_from_word_option (
		word_option: ZSTRING; set_boolean: PROCEDURE [ANY, TUPLE]
	)
			--
		do
			if word_option_exists (word_option) then
				set_boolean.apply
			end
		end

feature -- Status query

	has_integer (name: ZSTRING): BOOLEAN
		do
			Result := has_value (name) and then value (name).is_integer
		end

	has_value (name: ZSTRING): BOOLEAN
			--
		local
			unicode_name: READABLE_STRING_GENERAL
		do
			unicode_name := name.to_unicode
			Result := index_of_word_option (unicode_name) > 0 and then (index_of_word_option (unicode_name) + 1) <= argument_count
		end

	word_option_exists (word_option: ZSTRING): BOOLEAN
			--
		do
			Result := index_of_word_option (word_option.to_unicode) > 0
		end

	character_option_exists (character_option: CHARACTER_32): BOOLEAN
			--
		do
			Result := index_of_character_option (character_option) > 0
		end

end