note
	description: "Eiffel source code routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 13:04:49 GMT (Sunday 6th October 2024)"
	revision: "19"

expanded class
	EL_EIFFEL_SOURCE_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_GENERAL_ROUTINES

	EL_EIFFEL_KEYWORDS
		export
			{ANY} Class_declaration_keywords
		end

	EL_EIFFEL_CONSTANTS

	EL_SHARED_ZSTRING_CURSOR

feature -- Conversion

	class_name (a_text: READABLE_STRING_GENERAL): ZSTRING
		local
			break: BOOLEAN; i: INTEGER; c: CHARACTER; text: ZSTRING
		do
			text := as_zstring (a_text)
			create Result.make (text.count)
			if starts_with_upper_letter (text) then
				Result.append_character (text [1])
				from i := 2 until i > text.count or break loop
					c := text.item_8 (i)
					if Class_name_character_set.has (c) then
						Result.append_character (c)
					else
						break := True
					end
					i := i + 1
				end
			end
		end

	class_parameter_list (a_text: READABLE_STRING_GENERAL): EL_SEQUENTIAL_INTERVALS
		-- list of parameter type substring intervals
		require
			has_left_bracket: a_text.has ('[')
			all_brackets_matched: a_text.occurrences ('[') = a_text.occurrences (']')
		local
			i, index, upper, start_index, end_index: INTEGER; c: CHARACTER
			text: ZSTRING; appending: BOOLEAN
		do
			text := as_zstring (a_text)
			create Result.make (2)
			index := text.index_of ('[', 1)
			if index > 0 then
				upper:= cursor_z (text).matching_bracket_index (index) - 1
				from i := index + 1 until i > upper loop
					c := text.item_8 (i)
					if Class_name_character_set.has (c) then
						if appending then
							end_index := i
						else
							start_index := i
							end_index := i
							appending := True
						end
					else
						if appending then
							Result.extend (start_index, end_index)
							start_index := 0; end_index := 0
							appending := False
						end
					end
					i := i + 1
				end
				if start_index > 0 and then end_index - start_index + 1  > 0 then
					Result.extend (start_index, end_index)
				end
			end
		end

	parsed_class_name (a_text: READABLE_STRING_GENERAL): ZSTRING
		-- class name parsed from text with possible generic parameter list
		-- Eg. "HASH_TABLE [G, K -> HASHABLE]"
		local
			pos_bracket: INTEGER; text: ZSTRING
		do
			text := as_zstring (a_text)
			pos_bracket := text.index_of ('[', 1)
			if pos_bracket > 0 then
				-- remove class parameter
				Result := text.substring (1, pos_bracket - 1)
				Result.right_adjust
				Result := class_name (Result)
			else
				Result := class_name (text)
			end
		end

feature -- Status query

	is_class_definition_start (line: ZSTRING): BOOLEAN
		require
			valid_first_letters: across Class_declaration_keywords as list all
											is_first_letter_class_declaration (list.item.item_8 (1))
										end
		do
			if line.count > 0 and then is_first_letter_class_declaration (line.item_8 (1)) then
				Result := across Class_declaration_keywords as list some line.starts_with (list.item) end
			end
		end

	is_class_name (text: ZSTRING): BOOLEAN
		do
			Result := starts_with_upper_letter (text) and then text.is_subset_of_8 (Class_name_character_set)
		end

	is_first_letter_class_declaration (c: CHARACTER): BOOLEAN
		do
			inspect c
				when 'c', 'd', 'f', 'e' then
					Result := True
			else
			end
		end

	is_reserved_word (word: ZSTRING): BOOLEAN
		do
			Result := Reserved_word_set.has (word)
		end

	is_type_name (text: ZSTRING): BOOLEAN
		do
			Result := starts_with_upper_letter (text) and then text.is_subset_of_8 (Type_name_character_set)
		end

feature -- Basic operations

	enclose_class_parameters (code_text: ZSTRING)
		-- change for example: "${CONTAINER* [INTEGER_32]}" to "${CONTAINER*} [${INTEGER_32}]"
		local
			bracket_index: INTEGER; break: BOOLEAN
		do
			if attached class_parameter_list (code_text) as list then
				from list.finish until list.before loop
					if not is_parameter_name (code_text, list.item_lower, list.item_upper) then -- Excludes: G, KEY etc
						code_text.insert_character ('}', list.item_upper + 1)
						code_text.insert_string (Dollor_left_brace, list.item_lower)
					end
					list.back
				end
			-- Go backwards from '[' until last character of class name is found
				bracket_index := code_text.index_of ('[', 1)
				if bracket_index > 0 then
					from until break or bracket_index = 0 loop
						bracket_index := bracket_index - 1
						if code_text [bracket_index].is_alpha_numeric then
							break := True
						end
					end
					code_text.insert_character ('}', bracket_index + 1)
				end
				code_text.remove_tail (1)
			end
		-- "}*" -> "*}"
			code_text.replace_substring_all (Brace_asterisk, Asterisk_brace)
		end

feature {NONE} -- Implementation

	is_parameter_name (code_text: ZSTRING; start_index, end_index: INTEGER): BOOLEAN
		local
			index: INTEGER
		do
			if start_index = end_index then
				Result := True -- count is 1
			else
				index := code_text.substring_index (Constraint_symbol, end_index) -- finds "->"
				if index > 0 then
					Result := code_text.is_substring_whitespace (end_index + 1, index - 1)
				end
			end
		end

	starts_with_upper_letter (text: ZSTRING): BOOLEAN
		do
			if text.count > 0 then
				inspect text.item_8 (1)
					when 'A' .. 'Z' then
						Result := True
				else
				end
			end
		end

feature {NONE} -- Constants

	Asterisk_brace: ZSTRING
		once
			Result := "}*"
		end

	Brace_asterisk: ZSTRING
		once
			Result := "*}"
		end

end