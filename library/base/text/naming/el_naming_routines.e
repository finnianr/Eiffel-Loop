note
	description: "[
		Object with attribute names that are translateable TO and FROM another naming convention
		There are also routines to derive a name from the class generator name.
		
		Accessible from shared object_or_type `Naming' in class [$source EL_MODULE_NAMING]
	]"
	tests: "See: [$source EIFFEL_NAME_TRANSLATEABLE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-19 13:24:56 GMT (Saturday 19th August 2023)"
	revision: "41"

class
	EL_NAMING_ROUTINES

inherit
	ANY

	EL_STRING_8_CONSTANTS
		rename
			Empty_string_8 as Empty_name
		end

	EL_SHARED_STRING_8_CURSOR

feature -- Constants

	Empty_word_set: EL_HASH_SET [STRING]
		once
			create Result.make (0)
		end

	No_words: EL_STRING_8_LIST
		once
			create Result.make_empty
		end

feature -- Class name derivations

	class_as_camel (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		local
			l_name: STRING
		do
			l_name := class_as_snake_lower (object_or_type, head_count, tail_count)
			create Result.make (l_name.count)
			to_camel_case (l_name, Result, True)
		end

	class_as_kebab_lower (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		do
			Result := class_with_separator (object_or_type, '-', head_count, tail_count)
			Result.to_lower
		end

	class_as_kebab_upper (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		do
			Result := class_with_separator (object_or_type, '-', head_count, tail_count)
		end

	class_as_snake_lower (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		do
			Result := class_as_snake_upper (object_or_type, head_count, tail_count)
			Result.to_lower
		end

	class_as_snake_upper (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		do
			Result := class_with_separator (object_or_type, '_', head_count, tail_count)
		end

	class_description (a_type_name: STRING; excluded_words: EL_STRING_8_LIST): STRING
		-- derive English description from object or object type
		-- Words <= 3 are left capitalized
		-- Class parameters result in suffix " for type X"
		require
			using_no_words_for_empty: excluded_words.is_empty implies excluded_words = No_words
		local
			word_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
			word, name: STRING; s: EL_STRING_8_ROUTINES
		do
			name := s.substring_to (a_type_name, '[', default_pointer)
			name.right_adjust

			create word_split.make (name, '_')
			create Result.make (word_split.target.count)
			across word_split as split loop
				word := split.item
				if Result.count > 0 then
					Result.extend (' ')
				end
				if excluded_words.has (word) then
					if Result.count > 1 then
						Result.remove_tail (1)
					end
				else
					if word.count > 3 then
						word.to_lower
					end
					Result.append (word)
				end
			end
			Result [1] := Result [1].as_upper
			if name.count < a_type_name.count then
				name := s.substring_to_reversed (a_type_name, '[', default_pointer)
				name.remove_tail (1)
				Result.append (" for type ")
				Result.append (name)
			end
		end

	class_description_from (object_or_type: ANY; excluded_words: EL_STRING_8_LIST): STRING
		do
			Result := class_description (type_name (object_or_type), excluded_words)
		end

	class_with_separator (object_or_type: ANY; separator: CHARACTER; head_count, tail_count: INTEGER): STRING
		-- class name of `object_or_type' (object if not conforming to TYPE [ANY])
		-- with `head_count' words removed from head and `tail_count' words removed from tail
		require
			valid_head_tail_count: head_count + tail_count <= type_name (object_or_type).occurrences ('_') + 1
		local
			s: EL_STRING_8_ROUTINES; name: STRING
		do
			name := s.substring_to (type_name (object_or_type), ' ', default_pointer) -- Removes any generic parameters
			Result := s.sandwiched_parts (name, '_', head_count, tail_count)
			if separator /= '_' then
				s.replace_character (Result, '_', separator)
			end
		end

	class_with_separator_as_lower (object_or_type: ANY; separator: CHARACTER; head_count, tail_count: INTEGER): STRING
		do
			Result := class_with_separator (object_or_type, separator, head_count, tail_count)
			Result.to_lower
		end

feature -- Import names

	from_camel_case (name_in: READABLE_STRING_8; name_out: STRING)
		-- Eg. "fromCamelCase"
		require
			empty_name_out: name_out.is_empty
		local
			i, state, first_index, last_index: INTEGER; c: CHARACTER
		do
			if attached cursor_8 (name_in) as c8 and then attached c8.area as area then
				first_index := c8.area_first_index; last_index := c8.area_last_index
				if name_in.count > 0 then
					c := area.item (first_index)
					if c.is_digit then
						state := State_numeric
					elseif c.is_upper then
						state := State_upper
					else
						state := State_lower
					end
				end
				from i := first_index until i > last_index loop
					c := area.item (i)
					if state = State_numeric and not c.is_digit then
						if c.is_lower then
							state := State_lower
						else
							state := State_upper
						end
						name_out.append_character ('_')

					elseif state = State_lower and then c.is_upper or c.is_digit then
						state := State_upper; name_out.append_character ('_')

					elseif state = State_upper and then c.is_lower or c.is_digit then
						state := State_lower
					end
					name_out.append_character (c.as_lower)
					i := i + 1
				end
			end
		end

	from_camel_case_upper (name_in: READABLE_STRING_8; name_out: STRING; boundary_hints: ARRAY [STRING])
		-- Convert from UPPERCASECAMEL using word boundaries hints `boundary_hints'
		-- For example `<< "sub" >>' is sufficient to convert BUTTONSUBTYPE to
		-- button_sub_type.
		local
			i, count, pos: INTEGER; word: STRING; found: BOOLEAN
		do
			count := boundary_hints.count
			name_out.grow (name_in.count + 3)
			name_out.append (name_in)
			name_out.to_lower
			from i := 1 until found or i > count loop
				word := boundary_hints [i]
				pos := name_out.substring_index (word, 1)
				if pos > 0 then
					if pos > 1 and then name_out [pos - 1] /= '_' then
						name_out.insert_character ('_', pos)
						pos := pos + 1
					end
					if pos + word.count < name_out.count then
						name_out.insert_character ('_', pos + word.count)
					end
					found := True
				end
				i := i + 1
			end
		end

	from_kebab_case (name_in: READABLE_STRING_8; name_out: STRING)
		-- Eg. "from-kebab-case"
		do
			from_separated (name_in, name_out, '-')
		end

	from_separated (name_in: READABLE_STRING_8; name_out: STRING; separator: CHARACTER)
		-- from words separated by `separator'
		require
			empty_name_out: name_out.is_empty
		local
			s: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			name_out.to_lower
			s.replace_character (name_out, separator, '_')
		end

	from_snake_case_lower (name_in: READABLE_STRING_8; name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	from_snake_case_upper (name_in: READABLE_STRING_8; name_out: STRING)
		-- Eg. "FROM_UPPER_SNAKE_CASE"
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_lower
		end

feature -- Export names

	to_camel_case (name_in: READABLE_STRING_8; name_out: STRING; is_title: BOOLEAN)
		require
			empty_name_out: name_out.is_empty
		local
			i, first_index, last_index: INTEGER; c: CHARACTER; s: EL_STRING_8_ROUTINES
		do
			if name_in.has ('_') and then attached cursor_8 (name_in) as c8 and then attached c8.area as area then
				first_index := c8.area_first_index; last_index := c8.area_last_index
				from i := first_index until i > last_index loop
					c := area [i]
					if c = '_' then
						i := i + 1
						if i <= last_index then
							name_out.append_character (area.item (i).as_upper)
						end
					else
						name_out.append_character (c)
					end
					i := i + 1
				end
			else
				name_out.append (name_in)
			end
			if is_title then
				s.first_to_upper (name_out)
			end
		end

	to_camel_case_lower (name_in: READABLE_STRING_8; name_out: STRING)
		do
			to_camel_case (name_in, name_out, False)
			name_out.to_lower
		end

	to_camel_case_upper (name_in: READABLE_STRING_8; name_out: STRING)
		do
			to_camel_case (name_in, name_out, False)
			name_out.to_upper
		end

	to_english (name_in: READABLE_STRING_8; english_out: STRING; upper_case_words: like empty_word_set)
		require
			empty_name_out: english_out.is_empty
		local
			s: EL_STRING_8_ROUTINES; word: STRING
		do
			Underscore_split.set_target (name_in)
			across Underscore_split as list loop
				word := list.item
				if upper_case_words.has (word) then
					word.to_upper
				end
				if list.cursor_index = 1 then
					if word.count > 0 then
						s.set_upper (word, 1)
					end
				elseif s.caseless_ends_with (english_out, once "NON") then
					english_out.append_character ('-')

				else
					english_out.append_character (' ')
				end
				english_out.append (word)
			end
		end

	to_kebab_case (name_in: READABLE_STRING_8; name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		local
			s: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			s.replace_character (name_out, '_', '-')
		end

	to_kebab_case_lower (name_in: READABLE_STRING_8; name_out: STRING)
		do
			to_kebab_case (name_in, name_out)
			name_out.to_lower
		end

	to_kebab_case_upper (name_in: READABLE_STRING_8; name_out: STRING)
		do
			to_kebab_case (name_in, name_out)
			name_out.to_upper
		end

	to_snake_case_lower (name_in: READABLE_STRING_8; name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	to_snake_case_upper (name_in: READABLE_STRING_8; name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_upper
		end

	to_title (name_in: READABLE_STRING_8; title_out: STRING; separator_out: CHARACTER; uppercase_exception_set: EL_HASH_SET [STRING])
		require
			empty_title_out: title_out.is_empty
		local
			s: EL_STRING_8_ROUTINES; i: INTEGER; word: STRING
		do
			Underscore_split.set_target (name_in)
			across Underscore_split as list loop
				word := list.item
				if list.cursor_index > 1 then
					title_out.append_character (separator_out)
				end
				if word.count > 0 then
					if uppercase_exception_set.has_key (word) then
						word := uppercase_exception_set.found_item
						from i := 1 until i > word.count loop
							title_out.append_character (word [i].as_upper)
							i := i + 1
						end
					else
						list.append_item_to (title_out)
						s.set_upper (title_out, list.item_lower)
					end
				end
			end
		end

feature -- Contract Support

	type_name (object_or_type: ANY): STRING
		-- type name of object or object type
		do
			if attached {TYPE [ANY]} object_or_type as type then
				Result := {ISE_RUNTIME}.generating_type_of_type (type.type_id)
			else
				Result := object_or_type.generator
			end
		end

feature {NONE} -- Constants

	State_lower: INTEGER = 2

	State_numeric: INTEGER = 3

	State_upper: INTEGER = 1

	Underscore_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
		once
			create Result.make (Empty_name, '_')
		end

end