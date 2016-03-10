note
	description: "Pattern factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:48:18 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_TEXTUAL_PATTERN_FACTORY

inherit
	EL_MODULE_CHARACTER
		export
			{NONE} all
		end

--	EL_MODULE_LOG

feature -- Recursive patterns

	one_of_or_else_recursive_pattern (
		terminating_patterns: ARRAY [EL_TEXTUAL_PATTERN];
		a_recursive_pattern_factory_agent: FUNCTION [EL_TEXTUAL_PATTERN_FACTORY, TUPLE, EL_TEXTUAL_PATTERN]

	): EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make_with_possible_terminating_patterns (
				terminating_patterns,
				a_recursive_pattern_factory_agent
			)
		end

	pattern_1_or_else_recursive_pattern_2 (
		terminating_pattern: EL_TEXTUAL_PATTERN
		a_recursive_pattern_factory_agent: FUNCTION [EL_TEXTUAL_PATTERN_FACTORY, TUPLE, EL_TEXTUAL_PATTERN]

	): EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make_with_terminating_pattern (
				terminating_pattern,
				a_recursive_pattern_factory_agent
			)
		end

	one_of (array_of_alternatives: ARRAY [EL_TEXTUAL_PATTERN]): EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make (array_of_alternatives)
			Result.set_name ("one_of")
		end

	one_of_characters (array_of_alternatives: ARRAY [EL_SINGLE_CHAR_TEXTUAL_PATTERN]): EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			create Result.make (array_of_alternatives)
			Result.set_name ("one_of_characters")
		end

	all_of (array: ARRAY [EL_TEXTUAL_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
		end

	not_this (a_pattern: EL_TEXTUAL_PATTERN): EL_NEGATED_TEXTUAL_PATTERN
		do
			create Result.make (a_pattern)
		end

feature -- Constrained occurrences

	optional (optional_pattern: EL_TEXTUAL_PATTERN): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			--
		do
			Result := optional_pattern #occurs (0 |..| 1)
			Result.set_name ("optional")
		end

	zero (pattern: EL_TEXTUAL_PATTERN): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			--
		do
			Result := pattern #occurs (0 |..| 0)
			Result.set_name ("zero")
		end

	zero_or_more (repeated_pattern: EL_TEXTUAL_PATTERN): EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		do
			create Result.make (repeated_pattern)
			Result.set_name ("zero_or_more")
		end

	one_or_more (repeated_pattern: EL_TEXTUAL_PATTERN): EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			create Result.make (repeated_pattern)
			Result.set_name ("one_or_more")
		end

	while_not_pattern_1_repeat_pattern_2 (
		terminating_pattern, repeated_pattern: EL_TEXTUAL_PATTERN
	): EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
			--
		do
			create Result.make (terminating_pattern, repeated_pattern)
		end

	repeat_pattern_1_until_pattern_2 (
		repeated_pattern, terminating_pattern: EL_TEXTUAL_PATTERN
	): EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
			--
		do
			create Result.make (terminating_pattern, repeated_pattern)
		end

	repeat (pattern: EL_TEXTUAL_PATTERN; bounds: INTEGER_INTERVAL): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			--
		do
			create Result.make (pattern, bounds)
		end

feature  -- Basic patterns

	end_of_line_character: EL_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			create Result.make
		end

	any_character: EL_MATCH_ANY_CHAR_TP
			--
		do
			create Result
		end

	character_in_range (from_chr, to_chr: CHARACTER): EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (from_chr.code.to_natural_32, to_chr.code.to_natural_32)
		end

	character_in_code_range (from_code, to_code: NATURAL): EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (from_code, to_code)
		end

	one_character_from (a_character_set: STRING_GENERAL): EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	string_literal (literal: READABLE_STRING_GENERAL): EL_LITERAL_TEXTUAL_PATTERN
			--
		do
			create Result.make_from_string (create {EL_ASTRING}.make_from_unicode (literal))
			Result.set_name ("value (" + literal +")" )
		end

	character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make_from_character (literal)
		end

	character_code_literal (code: NATURAL_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (code)
		end

	token (a_token_id: NATURAL_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (a_token_id)
		end

	repeat_of_pattern_match (pattern: EL_TEXTUAL_PATTERN): EL_MATCH_PREVIOUSLY_MATCHED_TEXT_TP
			--
		do
			create Result.make_with_pattern (pattern)
		end

	start_of_line: EL_MATCH_BEGINNING_OF_LINE_TP
			-- Match start of line position
		do
			create Result
		end

feature -- Derived patterns

	maybe_white_space: EL_MATCH_ZERO_OR_MORE_TIMES_TP
			-- Matches even if no white space found
		do
			Result := zero_or_more (white_space_character)
			Result.set_name ("white_space")
		end

	white_space: EL_MATCH_ONE_OR_MORE_TIMES_TP
			-- Matches only if at least one white space character found
		do
			Result := one_or_more (white_space_character)
			Result.set_name ("white_space")
		end

	maybe_non_breaking_white_space: EL_MATCH_ZERO_OR_MORE_TIMES_TP
			-- Matches even if no white space found
		do
			Result := zero_or_more (non_breaking_white_space_character)
		end

	non_breaking_white_space: EL_MATCH_ONE_OR_MORE_TIMES_TP
			-- Matches only if at least one white space character found
		do
			Result := one_or_more (non_breaking_white_space_character)
		end

	all_of_separated_by (separator: EL_TEXTUAL_PATTERN; array: ARRAY [EL_TEXTUAL_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
			from
				Result.start
				Result.forth
			until
				Result.after
			loop
				Result.put_left (separator)
				Result.forth
			end
		ensure
			correct_number_inserted: Result.pattern_count = array.count * 2 - 1
		end

	whole_word (literal: STRING): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal (literal),
				not one_of (<<
					alpha_numeric,
					character_literal ('_')
				>>)
			>>)
--			Result.set_name ("whole_word")
--			Result.set_pattern_trace_on_to_depth (1)
		end

	remainder_of_line: EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		do
			Result := zero_or_more (not end_of_line_character)
		end

	integer: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (digit)
		end

	c_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of (<<
					letter,
					character_literal ('_')
				>> ),
				zero_or_more (identifier_character)
			>>)
		end

feature -- Quoted patterns

	encased_with_characters (pattern: EL_TEXTUAL_PATTERN; bookend_characters: STRING): EL_MATCH_ALL_IN_LIST_TP
			--
		require
			bookend_characters_has_count_of_two: bookend_characters.count = 2
		do
			Result := all_of (<<
				character_code_literal (bookend_characters.code (1)),
				pattern,
				character_code_literal (bookend_characters.code (2))
			>>)
		end

	quoted_string_with_escape_sequence (
		escape_sequence: EL_TEXTUAL_PATTERN;
		match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := bookended_string_with_escape_sequence (escape_sequence, "%"%"", match_action)
		end

	single_quoted_string_with_escape_sequence (
		escape_sequence: EL_TEXTUAL_PATTERN;
		match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := bookended_string_with_escape_sequence (escape_sequence, "''", match_action)
		end

	bookended_string_with_escape_sequence (
		escape_sequence: EL_TEXTUAL_PATTERN; bookends: STRING;
		match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		require
			two_bookends: bookends.count = 2
		local
			characters_plus_end_quote: EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
		do
			characters_plus_end_quote := while_not_pattern_1_repeat_pattern_2 (
				character_literal (bookends.item (2)),

				-- pattern 2
				one_of ( << escape_sequence, any_character >> )
			)
			Result := all_of ( <<
				character_literal (bookends.item (1)),
				characters_plus_end_quote
			>> )
			if match_action /= Default_match_action then
				characters_plus_end_quote.set_action_on_combined_repeated_match (match_action)
			end
		end

	quoted_character_with_escape_sequence (
		escape_sequence: EL_TEXTUAL_PATTERN; match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		local
			unquoted_character: EL_FIRST_MATCH_IN_LIST_TP
		do
			unquoted_character := one_of ( <<
				escape_sequence,
				any_character
			>> )
			if match_action /= Default_match_action then
				unquoted_character.set_action_on_match_begin (match_action)
			end
			Result := all_of ( <<
				character_literal ('%''),
				unquoted_character,
				character_literal ('%'')
			>> )
		end

feature -- Derived character patterns

	new_line_character: EL_END_OF_LINE_CHAR_TP
			--
		do
			create Result.make
		end

	digit: EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			Result := character_in_range ('0','9')
		end

	uppercase_letter: EL_SINGLE_CHAR_TEXTUAL_PATTERN
			--
		do
			Result := character_in_range ('A','Z')
		end

	lowercase_letter: EL_SINGLE_CHAR_TEXTUAL_PATTERN
			--
		do
			Result := character_in_range ('a','z')
		end

	uppercase_latin1_accented_letter: EL_SINGLE_CHAR_TEXTUAL_PATTERN
			--
		do
			Result := character_in_code_range (Character.Ucase_A_GRAVE, Character.Ucase_THORN)
						and not character_code_literal (Character.Multiply_sign)
		end

	lowercase_latin1_accented_letter: EL_SINGLE_CHAR_TEXTUAL_PATTERN
			--
		do
			Result := character_in_code_range (Character.Lcase_A_GRAVE, Character.Lcase_THORN)
						and not character_code_literal (Character.Division_sign)
		end

	latin1_letter: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<<
				letter, uppercase_latin1_accented_letter, lowercase_latin1_accented_letter,
				character_code_literal (Character.Sharp_s), character_code_literal (Character.Y_dieresis)
			>>)
		end

	latin1_alpha_numeric: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters ( <<
				latin1_letter, digit
			>> )
		end

	letter: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<< uppercase_letter, lowercase_letter >>)
			Result.set_name ("letter")
		end

	alpha_numeric: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<< letter, digit >>)
		end

	identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<< letter, digit, character_literal ('_') >>)
		end

	white_space_character: EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			Result := one_character_from ("%T%/32/%N%R")
		end

	non_breaking_white_space_character: EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			Result := one_character_from ("%T%/32/")
		end

feature {NONE} -- Constants

	Default_match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
		local
			l_pattern: EL_LITERAL_CHAR_TP
		once
			create l_pattern.make (0)
			Result := l_pattern.Default_match_action
		end

end -- class EL_TEXTUAL_PATTERN_FACTORY

