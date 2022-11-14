note
	description: "Factory to create new instances of text patterns"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 17:04:52 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_TEXT_PATTERN_FACTORY

inherit
	ANY

	EL_SHARED_OPTIMIZED_FACTORY

feature -- Recursive patterns

	all_of (array: ARRAY [EL_TEXT_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
		end

	one_of (array_of_alternatives: ARRAY [EL_TEXT_PATTERN]): EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make (array_of_alternatives)
		end

	recurse (new_recursive: FUNCTION [EL_TEXT_PATTERN]; unique_id: NATURAL): EL_RECURSIVE_TEXT_PATTERN
		do
			create Result.make (new_recursive, unique_id)
		end

feature -- String patterns

	string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
			--
		do
			Result := core.new_string_literal (a_text)
		end

	xml_identifier: EL_MATCH_XML_IDENTIFIER_TP
		-- match XML element or attribute name identifier
		do
			Result := core.new_xml_identifier
		end

feature -- Bounded occurrences

	one_or_more (repeated_pattern: EL_TEXT_PATTERN): EL_MATCH_ONE_OR_MORE_TIMES_TP
		--
		do
			create Result.make (repeated_pattern)
		end

	optional (optional_pattern: EL_TEXT_PATTERN): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		--
		do
			Result := optional_pattern #occurs (0 |..| 1)
		end

	while_not_p_match_any (p: EL_TEXT_PATTERN): EL_MATCH_ANY_WHILE_NOT_P_MATCH_TP
		--
		do
			create Result.make (p)
		end

	while_not_p1_repeat_p2 (p1, p2: EL_TEXT_PATTERN): EL_MATCH_P2_WHILE_NOT_P1_MATCH_TP
		do
			create Result.make (p1, p2)
		end

	zero_or_more (a_pattern: EL_TEXT_PATTERN): EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		do
			create Result.make (a_pattern)
		end

feature -- Character patterns

	any_character: EL_MATCH_ANY_CHAR_TP
			--
		do
			create Result
		end

	character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			Result := core.new_character_literal (literal)
		end

	digit: EL_NUMERIC_CHAR_TP
			--
		do
			Result := core.new_digit
		end

	end_of_line_character: EL_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			Result := core.new_end_of_line_character
		end

	letter: EL_ALPHA_CHAR_TP
			--
		do
			Result := core.new_letter
		end

	one_character_from (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_CHARACTER_IN_SET_TP
			--
		do
			Result := core.new_character_in_set (a_character_set)
		end

	white_space_character: EL_WHITE_SPACE_CHAR_TP
			--
		do
			Result := core.new_white_space_character
		end

feature -- White space

	non_breaking_white_space: EL_MATCH_WHITE_SPACE_TP
		-- match at least one nonbreaking white space
		do
			Result := core.new_white_space (False, True)
		end

	optional_nonbreaking_white_space: EL_MATCH_WHITE_SPACE_TP
		-- match optional nonbreaking white space
		do
			Result := core.new_white_space (True, True)
		end

	optional_white_space: EL_MATCH_WHITE_SPACE_TP
		-- match optional white space
		do
			Result := core.new_white_space (True, False)
		end

	white_space: EL_MATCH_WHITE_SPACE_TP
		-- match at least one white space
		do
			Result := core.new_white_space (False, False)
		end

feature -- Numeric strings

	decimal_constant: like all_of
		do
			Result := all_of (<<
				signed_integer,
				optional (all_of (<< character_literal ('.'), signed_integer >>))
			>>)
		end

	natural_number: EL_MATCH_DIGITS_TP
		do
			Result := core.new_digits_string (1)
		end

	signed_integer: like all_of
			--
		do
			Result := all_of (<<
				optional (character_literal ('-')), natural_number
			>>)
		end
feature {NONE} -- Constants

	OPTIONAL_ACTION: detachable PROCEDURE [INTEGER, INTEGER]
		once
			Result := Void
		end
end