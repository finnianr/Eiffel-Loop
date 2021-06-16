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
	date: "2021-06-16 10:43:07 GMT (Wednesday 16th June 2021)"
	revision: "21"

class
	EL_NAMING_ROUTINES

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
			l_name: STRING; s: EL_STRING_8_ROUTINES
		do
			l_name := class_as_snake_lower (object_or_type, head_count, tail_count)
			create Result.make (l_name.count)
			to_camel_case (l_name, Result)
			s.first_to_upper (Result)
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
			split_string: EL_SPLIT_STRING_LIST [STRING]; s: EL_STRING_8_ROUTINES
		do
			if attached {TYPE [ANY]} object_or_type as type then
				Result := type.name
			else
				Result := object_or_type.generator
			end
			if head_count + tail_count > 0 then
				create split_string.make (Result, s.character_string ('_'))
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
			s: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			name_out.to_lower
			s.replace_character (name_out, separator, '_')
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
			words: EL_SPLIT_STRING_LIST [STRING]
		do
			upper_case_words.compare_objects
			create words.make (name_in, Underscore)
			words.do_all (agent append_english_word (upper_case_words, ?, english_out))
			english_out [1] := english_out.item (1).as_upper
		end

	to_kebab_case (name_in, name_out: STRING)
		require
			empty_name_out: name_out.is_empty
		local
			s: EL_STRING_8_ROUTINES
		do
			name_out.append (name_in)
			s.replace_character (name_out, '_', '-')
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
			index: INTEGER; list: like Underscore_intervals
			s: EL_STRING_8_ROUTINES
		do
			list := Underscore_intervals
			list.fill (name_in, Underscore)
			title_out.append (name_in)
			list.put_front (0)
			from list.start until list.after loop
				index := list.item_lower
				if title_out.valid_index (index) then
					title_out [index] := separator_out
				end
				if title_out.valid_index (index + 1) then
					s.set_upper (title_out, index + 1)
				end
				list.forth
			end
		end

feature {NONE} -- Implementation

	append_english_word (upper_case_words: like no_words; word: STRING; str: STRING)
		do
			if not str.is_empty then
				if str.ends_with (once "non") then
					str.append_character ('-')
				else
					str.append_character (' ')
				end
			end
			if upper_case_words.has (word) then
				word.to_upper
			end
			str.append (word)
		end

feature {NONE} -- Constants

	State_lower: INTEGER = 2

	State_numeric: INTEGER = 3

	State_upper: INTEGER = 1

	Underscore: STRING = "_"

	Underscore_intervals: EL_OCCURRENCE_INTERVALS [STRING]
		once
			create Result.make_empty
		end

end