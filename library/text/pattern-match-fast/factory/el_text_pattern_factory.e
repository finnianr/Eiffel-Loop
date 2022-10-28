note
	description: "Factory to create new instances of text patterns"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:17:19 GMT (Friday 28th October 2022)"
	revision: "1"

deferred class
	EL_TEXT_PATTERN_FACTORY

feature -- Recursive patterns

	all_of (array: ARRAY [EL_TEXT_PATTERN]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			create Result.make (array)
		end

feature -- Basic patterns

	string_literal (a_text: READABLE_STRING_GENERAL): EL_LITERAL_TEXT_PATTERN
			--
		do
			Result := core.new_string_literal (a_text)
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

feature -- Core patterns

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

	letter: EL_ALPHA_CHAR_TP
			--
		do
			Result := core.new_letter
		end

feature {NONE} -- Implementation

	core: EL_CORE_PATTERN_FACTORY
		do
			if attached optimal_core as optimal then
				Result := optimal
			else
				Result := Core_general
			end
		end

	set_optimal_core (text: READABLE_STRING_GENERAL)
		-- set `optimal_core' factory with shared instance that is optimal for `text' type
		do
			if attached {ZSTRING} text then
				optimal_core := Core_zstring

			elseif attached {READABLE_STRING_8} text then
				optimal_core := Core_string_8

			else
				optimal_core := Core_general
			end
		end

feature {NONE} -- Internal attributes

	optimal_core: detachable EL_CORE_PATTERN_FACTORY

feature {NONE} -- Constants

	Core_general: EL_CORE_PATTERN_FACTORY
		once
			create Result
		end

	Core_string_8: EL_STRING_8_PATTERN_FACTORY
		once
			create Result
		end

	Core_zstring: EL_ZSTRING_PATTERN_FACTORY
		once
			create Result
		end
end







