note
	description: "Find and replace editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 12:06:27 GMT (Wednesday 7th August 2019)"
	revision: "5"

class
	FIND_AND_REPLACE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

create
	make

feature {NONE} -- Initialization

	make (a_find_text, a_replacement_text: ZSTRING)
			--
		do
			find_text := a_find_text; replacement_text := a_replacement_text
			make_default
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create Result.make_from_array (<< string_literal (find_text) |to| agent replace (?, replacement_text)>>)
		end

feature {NONE} -- Implementation

	find_text: ZSTRING

	replacement_text: ZSTRING
end
