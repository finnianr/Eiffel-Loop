note
	description: "Abstraction for joining strings using routines in ${EL_LINEAR [S]}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-03 10:14:48 GMT (Monday 3rd June 2024)"
	revision: "17"

deferred class
	EL_LINEAR_STRINGS [S -> STRING_GENERAL create make end]

inherit
	EL_LINEAR [S]

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Measurement

	checksum: NATURAL
		do
			push_cursor
			if attached crc_generator as crc then
				from start until after loop
					add_to_checksum (crc, item)
					forth
				end
				Result := crc.checksum
			end
			pop_cursor
		end

	hash_code: INTEGER
		-- Hash code value
		local
			i: INTEGER; b: EL_BIT_ROUTINES
		do
			push_cursor
			from start until after loop
				Result := b.extended_hash (Result, item.hash_code)
				forth
			end
			Result := Result.abs
			pop_cursor
		end

feature -- Access

	as_string_32_list: ARRAYED_LIST [STRING_32]
		do
			push_cursor
			create Result.make (current_count)
			from start until after loop
				Result.extend (item.as_string_32)
				forth
			end
			pop_cursor
		end

	as_string_list: EL_ARRAYED_LIST [like item]
			-- string delimited list
		do
			push_cursor
			create Result.make (current_count)
			from start until after loop
				Result.extend (item.twin)
				forth
			end
			pop_cursor
		end

	comma_separated: like item
		local
			quoted: BOOLEAN
		do
			push_cursor
			create Result.make (character_count + (current_count - 1).max (0) * 2)
			from start until after loop
				if index > 1 then
					Result.append (once ", ")
				end
				quoted := item.has (',')
				if quoted then
					Result.append_code ({EL_ASCII}.Doublequote)
				end
				Result.append (item)
				if quoted then
					Result.append_code ({EL_ASCII}.Doublequote)
				end
				forth
			end
			pop_cursor
		end

	joined (a_separator: CHARACTER_32): like item
		do
			Result := joined_with (a_separator, False)
		end

	joined_lines: like item
			-- joined with new line characters
		do
			Result := joined_with ('%N', False)
		end

	joined_propercase_words: like item
			-- joined with new line characters
		do
			Result := joined_with (' ', True)
		end

	joined_strings: like item
			-- join strings with no separator
		do
			create Result.make (character_count)
			append_to (Result)
		end

	joined_with (a_separator: CHARACTER_32; proper_case_words: BOOLEAN): like item
			-- Null character joins without separation
		local
			l_count: INTEGER
		do
			if a_separator.natural_32_code.to_boolean then
				l_count := character_count + (current_count - 1).max (0)
			else
				l_count := character_count
			end
			create Result.make (l_count)
			append_to_with (Result, a_separator, proper_case_words)
		end

	joined_with_string (a_separator: READABLE_STRING_GENERAL): like item
		do
			create Result.make (character_count + (current_count - 1) * a_separator.count)
			append_separated_to (Result, a_separator)
		end

	joined_words: like item
			-- joined with space character
		do
			Result := joined_with (' ', False)
		end

feature -- Basic operations

	append_separated_to (str: like item; separator_general: READABLE_STRING_GENERAL)
		-- append parts to `str' using separator string `separator_general'
		local
			separator: like item
		do
			push_cursor
			create separator.make (separator_general.count)
			separator.append (separator_general)
			from start until after loop
				if index > 1 then
					str.append (separator)
				end
				str.append (item)
				forth
			end
			pop_cursor
		end

	append_to (str: like item)
		-- append parts to `str' with no separator
		do
			push_cursor
			from start until after loop
				str.append (item)
				forth
			end
			pop_cursor
		end

	append_to_with (str: like item; a_separator: CHARACTER_32; proper_case_words: BOOLEAN)
			-- append parts to `str' with `a_separator'
			-- if `a_separator = '%U'' then separator is not appended
		local
			code: NATURAL
		do
			push_cursor
			code := separator_code (a_separator)
			from start until after loop
				if index > 1 and code.to_boolean then
					append_code (str, code)
				end
				if proper_case_words then
					str.append (proper_cased (item))
				else
					str.append (item)
				end
				forth
			end
			pop_cursor
		end

	find_first_same (general: READABLE_STRING_GENERAL)
		do
			from start until after or else item.same_string (general) loop
				forth
			end
		end

feature -- Measurement

	character_count: INTEGER
			--
		do
			push_cursor
			from start until after loop
				Result := Result + item.count
				forth
			end
			pop_cursor
		end

	joined_character_count: INTEGER
			--
		do
			Result := character_count + (current_count - 1)
		end

feature {NONE} -- Implementation

	add_to_checksum (crc: like crc_generator; str: STRING_GENERAL)
		do
			crc.add_string_general (str)
		end

	append_code (str: like item; code: NATURAL)
		do
			str.append_code (code)
		end

	proper_cased (word: like item): like item
		do
			Result := word.as_lower
			Result.put_code (word.item (1).as_upper.natural_32_code, 1)
		end

	separator_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := a_separator.natural_32_code
		end

note
	descendants: "[
			EL_LINEAR_STRINGS* [S -> ${STRING_GENERAL} create make end]
				${EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]}
					${EL_SPLIT_STRING_8_LIST}
					${EL_SPLIT_STRING_32_LIST}
					${EL_SPLIT_ZSTRING_LIST}
				${EL_STRING_CHAIN* [S -> STRING_GENERAL create make end]}
					${EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]}
					${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
						${EL_STRING_8_LIST}
							${EVOLICITY_VARIABLE_REFERENCE}
								${EVOLICITY_FUNCTION_REFERENCE}
							${AIA_CANONICAL_REQUEST}
						${EL_STRING_32_LIST}
						${EL_ZSTRING_LIST}
							${EL_XHTML_STRING_LIST}
							${XML_TAG_LIST}
								${XML_PARENT_TAG_LIST}
								${XML_VALUE_TAG_PAIR}
							${TB_HTML_LINES}
							${EL_ERROR_DESCRIPTION}
								${EL_COMMAND_ARGUMENT_ERROR}
						${EL_TEMPLATE_LIST* [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]}
							${EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
								${EL_STRING_8_TEMPLATE}
								${EL_STRING_32_TEMPLATE}
								${EL_ZSTRING_TEMPLATE}
							${EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
								${EL_DATE_TEXT_TEMPLATE}
	]"
end