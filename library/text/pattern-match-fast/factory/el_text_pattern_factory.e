note
	description: "Factory to create new instances of text patterns"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 16:37:16 GMT (Monday 31st October 2022)"
	revision: "4"

deferred class
	EL_TEXT_PATTERN_FACTORY

feature -- Recursive patterns

	all_of (array: ARRAY [EL_TEXT_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
		end

feature -- String patterns

	c_identifier: EL_MATCH_C_IDENTIFIER_TP
		do
			Result := core.new_c_identifier
		end

	string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
			--
		do
			Result := core.new_string_literal (a_text)
		end

	xml_identifier: EL_MATCH_XML_IDENTIFIER_TP
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

	zero_or_more (a_pattern: EL_TEXT_PATTERN): EL_MATCH_ZERO_OR_MORE_TIMES_TP
			--
		do
			create Result.make (a_pattern)
		end

feature -- Character patterns

	character_literal (literal: CHARACTER_32): EL_LITERAL_CHAR_TP
			--
		do
			Result := core.new_character_literal (literal)
		end

	one_character_from (a_character_set: READABLE_STRING_GENERAL): EL_MATCH_CHARACTER_IN_SET_TP
			--
		do
			Result := core.new_character_in_set (a_character_set)
		end

	digit: EL_NUMERIC_CHAR_TP
			--
		do
			Result := core.new_digit
		end

	letter: EL_ALPHA_CHAR_TP
			--
		do
			Result := core.new_letter
		end

	white_space_character: EL_WHITE_SPACE_CHAR_TP
			--
		do
			Result := core.new_white_space_character
		end

feature -- White space

	maybe_white_space: EL_MATCH_WHITE_SPACE_TP
		-- Matches even if no white space found
		do
			Result := core.new_white_space (0)
		end

	maybe_nonbreaking_white_space: EL_MATCH_WHITE_SPACE_TP
			-- Matches even if no white space found
		do
			Result := core.new_nonbreaking_white_space (0)
		end

	non_breaking_white_space: EL_MATCH_WHITE_SPACE_TP
			-- Matches only if at least one white space character found
		do
			Result := core.new_nonbreaking_white_space (1)
		end

	white_space: EL_MATCH_WHITE_SPACE_TP
		-- Matches only if at least one white space character found
		do
			Result := core.new_white_space (1)
		end

feature -- Numeric strings

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

	decimal_constant: like all_of
		do
			Result := all_of (<<
				signed_integer,
				optional (all_of (<< character_literal ('.'), signed_integer >>))
			>>)
		end

feature {NONE} -- Implementation

	core: EL_OPTIMIZED_PATTERN_FACTORY
		do
			if attached optimal_core as optimal then
				Result := optimal
			else
				Result := Optimal_general
			end
		end

	set_optimal_core (text: READABLE_STRING_GENERAL)
		-- set `optimal_core' factory with shared instance that is optimal for `text' type
		do
			if attached {ZSTRING} text then
				optimal_core := Optimal_zstring

			elseif attached {READABLE_STRING_8} text then
				optimal_core := Optimal_string_8

			else
				optimal_core := Optimal_general
			end
		end

feature {NONE} -- Internal attributes

	optimal_core: detachable EL_OPTIMIZED_PATTERN_FACTORY

feature {NONE} -- Constants

	Optimal_general: EL_OPTIMIZED_PATTERN_FACTORY
		once
			create Result
		end

	Optimal_string_8: EL_STRING_8_PATTERN_FACTORY
		once
			create Result
		end

	Optimal_zstring: EL_ZSTRING_PATTERN_FACTORY
		once
			create Result
		end
end




