note
	description: "Text matcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 19:30:30 GMT (Tuesday 1st November 2022)"
	revision: "7"

class
	EL_TEXT_MATCHER

inherit
	EL_PARSER
		rename
			new_pattern as default_pattern
		end

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
		end

feature -- Element change

	set_pattern (a_pattern: like pattern)
		do
			internal_pattern := a_pattern
		end

feature -- Basic operations

	is_match (string: ZSTRING): BOOLEAN
			--
		do
			set_source_text (string)
			match_full
			Result := fully_matched
		end

	contains_match (string: ZSTRING): BOOLEAN
			--
		do
			Result := occurrences (string) > 1
		end

	occurrences (string: ZSTRING): INTEGER
			--
		local
			l_result: INTEGER_REF
		do
			create l_result
			set_source_text (string)
			pattern.set_action (agent increment (?, l_result))
			find_all
			Result := l_result
		end

	deleted (string: ZSTRING): ZSTRING
		-- string with all occurrences of pattern deleted
		do
			create Result.make (string.count)
			set_source_text (string)
			unmatched_action := agent append (Result, ?)
			find_all
		end

feature {NONE} -- Implementation

	append (string: ZSTRING; match: EL_STRING_VIEW)
		do
			string.append (match.to_string)
		end

	increment (matched_text: EL_STRING_VIEW; count: INTEGER_REF)
		do
			count.set_item (count + 1)
		end

	default_pattern: EL_MATCH_BEGINNING_OF_LINE_TP
			--
		do
			create Result.make
		end

end