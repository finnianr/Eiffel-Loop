note
	description: "Text matcher for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:26:46 GMT (Tuesday 15th April 2025)"
	revision: "13"

class
	EL_TEXT_MATCHER

inherit
	EL_ZSTRING_PARSER

	TP_FACTORY
		export
			{NONE} all
		end

	EL_NEW_PATTERN_BY_AGENT
		rename
			make_with_agent as make
		end

create
	make

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
			pattern.set_action (agent increment (?, ?, l_result))
			find_all (Void)
			Result := l_result
		end

	deleted (string: ZSTRING): ZSTRING
		-- string with all occurrences of pattern deleted
		do
			create Result.make (string.count)
			set_source_text (string)
			find_all (agent append (Result, ?, ?))
		end

feature {NONE} -- Implementation

	append (string: ZSTRING; start_index, end_index: INTEGER)
		do
			string.append (source_substring (start_index, end_index, False))
		end

	increment (start_index, end_index: INTEGER; count: INTEGER_REF)
		do
			count.set_item (count + 1)
		end

end