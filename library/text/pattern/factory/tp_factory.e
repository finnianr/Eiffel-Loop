note
	description: "Factory to create new instances of text patterns"
	notes: "[
		Implement **optimal_core** feature using ${TP_SHARED_OPTIMIZED_FACTORY}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "13"

deferred class
	TP_FACTORY

feature -- Recursive patterns

	all_of (array: ARRAY [TP_PATTERN]): TP_ALL_IN_LIST
			--
		do
			create Result.make (array)
		end

	all_of_separated_by (a_white_space: TP_WHITE_SPACE; array: ARRAY [TP_PATTERN]): like all_of
			--
		do
			create Result.make_separated (array, a_white_space)
		end

	one_of (array_of_alternatives: ARRAY [TP_PATTERN]): TP_FIRST_MATCH_IN_LIST
			--
		do
			create Result.make (array_of_alternatives)
		end

	recurse (new_recursive: FUNCTION [TP_PATTERN]; unique_id: NATURAL): TP_RECURSIVE_PATTERN
		local
			merged_id, current_type_id: INTEGER
		do
			current_type_id := {ISE_RUNTIME}.dynamic_type (Current)
			merged_id := (current_type_id |<< 16) | {ISE_RUNTIME}.dynamic_type (new_recursive)
			create Result.make (new_recursive, merged_id.to_natural_32 + unique_id)
		end

feature -- String patterns

	string_literal (a_text: READABLE_STRING_GENERAL): TP_LITERAL_PATTERN
			--
		do
			Result := core.new_string_literal (a_text)
		end

	string_literal_caseless (a_text: READABLE_STRING_GENERAL): TP_LITERAL_PATTERN
		-- case insensitive match of `a_text'
		do
			create Result.make_caseless (a_text)
		end

	quoted_string (
		quote: CHARACTER_32; unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	): TP_BASIC_QUOTED_STRING
		do
			Result := core.new_quoted_string (quote, unescaped_action)
		end

	xml_identifier: TP_XML_IDENTIFIER
		-- match XML element or attribute name identifier
		do
			Result := core.new_xml_identifier
		end

feature -- Bounded occurrences

	one_or_more (repeated_pattern: TP_PATTERN): TP_ONE_OR_MORE_TIMES
		--
		do
			create Result.make (repeated_pattern)
		end

	optional (optional_pattern: TP_PATTERN): TP_COUNT_WITHIN_BOUNDS
		--
		do
			Result := optional_pattern #occurs (0 |..| 1)
		end

	repeat_p1_until_p2 (p1, p2: TP_PATTERN ): TP_P1_UNTIL_P2_MATCH
			--
		do
			create Result.make (p1, p2)
		end

	while_not_p_match_any (p: TP_PATTERN): TP_ANY_WHILE_NOT_P_MATCH
		--
		do
			create Result.make (p)
		end

	while_not_p1_repeat_p2 (p1, p2: TP_PATTERN): TP_P2_WHILE_NOT_P1_MATCH
		do
			create Result.make (p1, p2)
		end

	zero_or_more (a_pattern: TP_PATTERN): TP_ZERO_OR_MORE_TIMES
			--
		do
			create Result.make (a_pattern)
		end

feature -- Line ends

	end_of_line_character: TP_END_OF_LINE_CHAR
			-- Matches new line or EOF
		do
			Result := core.new_end_of_line_character
		end

	start_of_line: TP_BEGINNING_OF_LINE
			-- Match start of line position
		do
			Result := core.new_start_of_line
		end

feature -- Character patterns

	alphanumeric: TP_ALPHANUMERIC_CHAR
			--
		do
			Result := core.new_alphanumeric
		end

	any_character: TP_ANY_CHAR
			--
		do
			create Result
		end

	character_literal (literal: CHARACTER_32): TP_LITERAL_CHAR
			--
		do
			Result := core.new_character_literal (literal)
		end

	character_in_range (lower, upper: CHARACTER): TP_CHAR_IN_ASCII_RANGE
			--
		do
			Result := core.new_character_in_range (lower, upper)
		end

	digit: TP_NUMERIC_CHAR
		do
			Result := core.new_digit
		end

	letter: TP_ALPHA_CHAR
			--
		do
			Result := core.new_letter
		end

	one_character_from (a_character_set: READABLE_STRING_GENERAL): TP_CHARACTER_IN_SET
			--
		do
			Result := core.new_character_in_set (a_character_set)
		end

	white_space_character: TP_WHITE_SPACE_CHAR
			--
		do
			Result := core.new_white_space_character
		end

feature -- White space

	nonbreaking_white_space: TP_WHITE_SPACE
		-- match at least one nonbreaking white space
		do
			Result := core.new_white_space (False, True)
		end

	optional_nonbreaking_white_space: TP_WHITE_SPACE
		-- match optional nonbreaking white space
		do
			Result := core.new_white_space (True, True)
		end

	optional_white_space: TP_WHITE_SPACE
		-- match optional white space
		do
			Result := core.new_white_space (True, False)
		end

	white_space: TP_WHITE_SPACE
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

	hexadecimal_constant: like all_of
		do
			Result := all_of (<< string_literal_caseless ("0x"), core.new_hexadecimal_string (1) >>)
		end

	natural_number: TP_DIGITS
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

feature -- Derived character patterns

	remainder_of_line: like zero_or_more
			--
		do
			Result := zero_or_more (not end_of_line_character)
		end

feature {NONE} -- Implementation

	core: TP_OPTIMIZED_FACTORY
		deferred
		end

feature {NONE} -- Type definition

	OPTIONAL_ACTION: detachable PROCEDURE [INTEGER, INTEGER]
		once
			Result := Void
		end
end