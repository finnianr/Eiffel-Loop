note
	description: "[
		Object with attribute names that are translateable TO and FROM another naming convention
		There are also routines to derive a name from the class generator name.
		
		Accessible from shared object_or_type `Naming' in class [$source EL_MODULE_NAMING]
	]"
	tests: "See: [$source EIFFEL_NAME_TRANSLATEABLE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:24:53 GMT (Sunday 26th December 2021)"
	revision: "25"

class
	EL_NAMING_ROUTINES

inherit
	ANY

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create no_words.make_empty
		end

feature -- Access

	no_words: ARRAY [STRING]

feature -- Class name derivations

	class_as_camel (object_or_type: ANY; head_count, tail_count: INTEGER): STRING
		local
			string_8: EL_STRING_8_ROUTINES; l_name: STRING
		do
			l_name := class_as_snake_lower (object_or_type, head_count, tail_count)
			create Result.make (l_name.count)
			to_camel_case (l_name, Result)
			string_8.first_to_upper (Result)
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

	class_with_separator (object_or_type: ANY; separator: CHARACTER; head_count, tail_count: INTEGER): STRING
		-- class name of `object_or_type' (object if not conforming to TYPE [ANY])
		-- with `head_count' words removed from head and `tail_count' words removed from tail
		local
			split_string: EL_SPLIT_STRING_LIST [STRING]
		do
			if attached {TYPE [ANY]} object_or_type as type then
				Result := type.name
			else
				Result := object_or_type.generator
			end
			if head_count + tail_count > 0 then
				create split_string.make (Result, '_')
				if head_count > 0 then
					split_string.remove_head (head_count)
				end
				if tail_count > 0 then
					split_string.remove_tail (tail_count)
				end
				Result := split_string.joined (separator)
			end
		end

	class_with_separator_as_lower (object_or_type: ANY; separator: CHARACTER; head_count, tail_count: INTEGER): STRING
		do
			Result := class_with_separator (object_or_type, separator, head_count, tail_count)
			Result.to_lower
		end

feature -- Import names

	from_camel_case (name_in, name_out: STRING)
		-- Eg. "fromCamelCase"
		require
			empty_name_out: name_out.is_empty
		local
			i, count, state: INTEGER; area: SPECIAL [CHARACTER]; c: CHARACTER
		do
			count := name_in.count; area := name_in.area

			if count > 0 then
				c := area.item (0)
				if c.is_digit then
					state := State_numeric
				elseif c.is_upper then
					state := State_upper
				else
					state := State_lower
				end
			end
			from i := 0 until i = count loop
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

	from_camel_case_upper (name_in, name_out: STRING; boundary_hints: ARRAY [STRING])
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

	from_kebab_case (name_in, name_out: STRING)
		-- Eg. "from-kebab-case"
		do
			from_separated (name_in, name_out, '-')
		end

	from_separated (name_in, name_out: STRING; separator: CHARACTER)
		-- from words separated by `separator'
		require
			empty_name_out: name_out.is_empty
		local
			string_8: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			name_out.to_lower
			string_8.replace_character (name_out, separator, '_')
		end

	from_snake_case_lower (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	from_snake_case_upper (name_in, name_out: STRING)
		-- Eg. "FROM_UPPER_SNAKE_CASE"
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_lower
		end

feature -- Export names

	to_camel_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		local
			i, count: INTEGER; area: SPECIAL [CHARACTER]; c: CHARACTER
		do
			if name_in.has ('_') then
				count := name_in.count; area := name_in.area
				from i := 0 until i = count loop
					c := area [i]
					if c = '_' then
						i := i + 1
						if i < count then
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
		end

	to_camel_case_lower (name_in, name_out: STRING)
		do
			to_camel_case (name_in, name_out)
			name_out.to_lower
		end

	to_camel_case_upper (name_in, name_out: STRING)
		do
			to_camel_case (name_in, name_out)
			name_out.to_upper
		end

	to_english (name_in, english_out: STRING; upper_case_words: like no_words)
		require
			empty_name_out: english_out.is_empty
		local
			string_8: EL_STRING_8_ROUTINES word: STRING
		do
			upper_case_words.compare_objects
			Underscore_split.set_target (name_in)
			across Underscore_split as list loop
				word := list.item
				if upper_case_words.has (word) then
					word.to_upper
				end
				if list.cursor_index = 1 then
					if word.count > 0 then
						string_8.set_upper (word, 1)
					end
				elseif english_out.ends_with (once "NON") then
					english_out.append_character ('-')

				elseif english_out.ends_with (once "non") then
					english_out.append_character ('-')
				else
					english_out.append_character (' ')
				end
				english_out.append (word)
			end
		end

	to_kebab_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		local
			string_8: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			string_8.replace_character (name_out, '_', '-')
		end

	to_kebab_case_lower (name_in, name_out: STRING)
		do
			to_kebab_case (name_in, name_out)
			name_out.to_lower
		end

	to_kebab_case_upper (name_in, name_out: STRING)
		do
			to_kebab_case (name_in, name_out)
			name_out.to_upper
		end

	to_snake_case_lower (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
		end

	to_snake_case_upper (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		do
			name_out.append (name_in)
			name_out.to_upper
		end

	to_title (name_in, title_out: STRING; separator_out: CHARACTER)
		require
			empty_title_out: title_out.is_empty
		local
			string_8: EL_STRING_8_ROUTINES
		do
			Underscore_split.set_target (name_in)
			across Underscore_split as list loop
				if list.cursor_index > 1 then
					title_out.append_character (separator_out)
				end
				if list.item_count > 0 then
					list.append_item_to (title_out)
					string_8.set_upper (title_out, list.item_lower)
				end
			end
		end

feature {NONE} -- Constants

	State_lower: INTEGER = 2

	State_numeric: INTEGER = 3

	State_upper: INTEGER = 1

	Underscore_split: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make (Empty_string_8, '_')
		end

end