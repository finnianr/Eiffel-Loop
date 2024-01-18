note
	description: "Text matcher for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "10"

class
	EL_TEXT_MATCHER

inherit
	EL_PARSER
		redefine
			default_source_text
		end

	TP_FACTORY
		export
			{NONE} all
		end

	EL_NEW_PATTERN_BY_AGENT
		rename
			make_with_agent as make
		end

	EL_ZSTRING_CONSTANTS

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

	default_source_text: ZSTRING
		do
			Result := Empty_string
		end

end