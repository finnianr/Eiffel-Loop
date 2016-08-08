note
	description: "Summary description for {EIFFEL_FIND_AND_REPLACE_SOURCE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 7:40:34 GMT (Thursday 4th August 2016)"
	revision: "2"

class
	EIFFEL_FIND_AND_REPLACE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

create
	make

feature {NONE} -- Initialization

	make (a_find_text: like find_text; a_replacement_text: like replacement_text)
			--
		do
			find_text := a_find_text
			replacement_text := a_replacement_text
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
