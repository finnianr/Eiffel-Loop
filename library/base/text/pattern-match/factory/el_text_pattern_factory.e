note
	description: "Summary description for {EL_TEXT_PATTERN_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-11 12:22:22 GMT (Monday 11th January 2016)"
	revision: "4"

class
	EL_TEXT_PATTERN_FACTORY

feature -- Recursive patterns

	all_of (array: ARRAY [EL_TEXT_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
		end

	all_of_separated_by (separator: EL_TEXT_PATTERN; array: ARRAY [EL_TEXT_PATTERN]): like all_of
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

	one_of (array_of_alternatives: ARRAY [EL_TEXT_PATTERN]): EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			create Result.make (array_of_alternatives)
		end

	one_of_characters (alternatives: ARRAY [EL_SINGLE_CHAR_TEXT_PATTERN]): EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			create Result.make (alternatives)
		end

	recurse (new_recursive: like recurse.new_recursive; has_action: BOOLEAN): EL_RECURSIVE_TEXT_PATTERN
		do
			create Result.make (new_recursive, has_action)
		end

feature -- Bounded occurrences

	optional (optional_pattern: EL_TEXT_PATTERN): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			--
		do
			Result := optional_pattern #occurs (0 |..| 1)
		end

	one_or_more (repeated_pattern: EL_TEXT_PATTERN): EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			create Result.make (repeated_pattern)
		end

	repeat_p1_until_p2 (p1, p2: EL_TEXT_PATTERN ): EL_MATCH_P1_UNTIL_P2_MATCH_TP
			--
		do
			create Result.make (p1, p2)
		end

	while_not_p1_repeat_p2 (p1, p2: EL_TEXT_PATTERN ): EL_MATCH_P2_WHILE_NOT_P1_MATCH_TP
			--
		do
			create Result.make (p1, p2)
		end

	zero_or_more (a_pattern: EL_TEXT_PATTERN): EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		do
			create Result.make (a_pattern)
		end

feature -- Basic patterns

	alphanumeric: EL_ALPHANUMERIC_CHAR_TP
			--
		do
			create Result.make
		end

	any_character: EL_MATCH_ANY_CHAR_TP
			--
		do
			create Result.make
		end

	character_code_literal (code: NATURAL_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (code)
		end

	character_in_range (from_chr, to_chr: CHARACTER): EL_MATCH_CHAR_IN_ASCII_RANGE_TP
			--
		do
			create Result.make (from_chr.code.to_natural_32, to_chr.code.to_natural_32)
		end

	character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make_from_character (literal)
		end

	digit: EL_NUMERIC_CHAR_TP
			--
		do
			create Result.make
		end

	end_of_line_character: EL_END_OF_LINE_CHAR_TP
			-- Matches new line or EOF
		do
			create Result.make
		end

	letter: EL_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

	lowercase_letter: EL_LOWERCASE_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

	non_breaking_white_space_character: EL_NON_BREAKING_WHITE_SPACE_CHAR_TP
			--
		do
			create Result.make
		end

	one_character_from (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			create Result.make (a_character_set)
		end

	previously_matched (pattern: EL_TEXT_PATTERN): EL_BACK_REFERENCE_MATCH_TP
			-- match of previously matched pattern
		do
			create Result.make (pattern)
		end

	start_of_line: EL_MATCH_BEGINNING_OF_LINE_TP
			-- Match start of line position
		do
			create Result.make
		end

	string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
			--
		do
			create Result.make_from_string (a_text)
		end

	token (a_token_id: NATURAL_32): EL_LITERAL_CHAR_TP
			--
		do
			create Result.make (a_token_id)
		end

	uppercase_letter: EL_UPPERCASE_ALPHA_CHAR_TP
			--
		do
			create Result.make
		end

	white_space_character: EL_WHITE_SPACE_CHAR_TP
			--
		do
			create Result.make
		end

feature -- Derived character patterns

	c_identifier: like all_of
			--
		do
			Result := all_of (<< one_of (<< letter, character_literal ('_') >>), zero_or_more (identifier_character) >>)
		end

	identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<< alphanumeric, character_literal ('_') >>)
		end

	integer: like one_or_more
			--
		do
			Result := one_or_more (digit)
		end

	maybe_white_space: like zero_or_more
			-- Matches even if no white space found
		do
			Result := zero_or_more (white_space_character)
		end

	maybe_non_breaking_white_space: like zero_or_more
			-- Matches even if no white space found
		do
			Result := zero_or_more (non_breaking_white_space_character)
		end

	non_breaking_white_space: like one_or_more
			-- Matches only if at least one white space character found
		do
			Result := one_or_more (non_breaking_white_space_character)
		end

	remainder_of_line: like zero_or_more
			--
		do
			Result := zero_or_more (not end_of_line_character)
		end

	white_space: EL_MATCH_ONE_OR_MORE_TIMES_TP
			-- Matches only if at least one white space character found
		do
			Result := one_or_more (white_space_character)
		end

	whole_word (literal: READABLE_STRING_GENERAL): like all_of
			--
		do
			Result := all_of (<<
				string_literal (literal),
				not one_of (<<
					alphanumeric,
					character_literal ('_')
				>>)
			>>)
		end

feature -- Quoted patterns

	encased_with_characters (pattern: EL_TEXT_PATTERN; bookend_characters: STRING): like all_of
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

	quoted_string (escape_sequence: EL_TEXT_PATTERN; a_action: like Default_action): like all_of
			--
		do
			Result := bookended_string (escape_sequence, "%"%"", a_action)
		end

	single_quoted_string (escape_sequence: EL_TEXT_PATTERN; a_action: like Default_action): like all_of
			--
		do
			Result := bookended_string (escape_sequence, "''", a_action)
		end

	bookended_string (
		escape_sequence: EL_TEXT_PATTERN; bookends: STRING; a_action: like Default_action
	): like all_of
			--
		require
			two_bookends: bookends.count = 2
		local
			characters_plus_end_quote: like while_not_p1_repeat_p2
		do
			characters_plus_end_quote := while_not_p1_repeat_p2 (
				character_literal (bookends.item (2)),

				-- pattern 2
				one_of ( << escape_sequence, any_character >> )
			)
			Result := all_of (<< character_literal (bookends.item (1)), characters_plus_end_quote >>)
			characters_plus_end_quote.set_action_combined_p2 (a_action)
		end

	quoted_character (escape_sequence: EL_TEXT_PATTERN; a_action: like Default_action): like all_of
			--
		local
			unquoted_character: like one_of
		do
			unquoted_character := one_of ( << escape_sequence, any_character >> )
			unquoted_character.set_action_first (a_action)
			Result := all_of (<< single_quote, unquoted_character, single_quote >>)
		end

	single_quote: like character_literal
		do
			Result := character_literal ('%'')
		end

feature {NONE} -- Constants

	Default_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
		local
			l_pattern: EL_LITERAL_CHAR_TP
		once
			create l_pattern.make (0)
			Result := l_pattern.Default_action
		end
end
