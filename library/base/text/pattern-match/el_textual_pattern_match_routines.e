note
	description: "Textual pattern match routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_TEXTUAL_PATTERN_MATCH_ROUTINES

inherit
	EL_TEXT_MATCHER
		rename
			is_match as is_text_match,
			contains_match as text_contains_match,
			occurrences as text_occurrences
		end

	EL_TEXT_PATTERN_FACTORY
		export
			{ANY} all
		end

create
	make

feature -- Basic operations

	is_match (a_string: ZSTRING; a_pattern: EL_TEXT_PATTERN): BOOLEAN
			--
		do
			pattern := a_pattern
			Result := is_text_match (a_string)
		end

	contains_match (a_string: ZSTRING; a_pattern: EL_TEXT_PATTERN): BOOLEAN
			--
		do
			Result := occurrences (a_string, a_pattern) > 1
		end

	occurrences (a_string: ZSTRING; a_pattern: EL_TEXT_PATTERN): INTEGER
			--
		do
			pattern := a_pattern
			Result := text_occurrences (a_string)
		end

end