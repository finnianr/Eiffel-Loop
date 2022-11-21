note
	description: "Find and replace editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:38:40 GMT (Monday 21st November 2022)"
	revision: "12"

class
	FIND_AND_REPLACE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR
		redefine
			edit
		end

create
	make

feature {NONE} -- Initialization

	make (a_find_text, a_replacement_text: ZSTRING)
			--
		do
			find_text := a_find_text; replacement_text := a_replacement_text
			make_default
		end

feature -- Basic operations

	edit
		do
			if source_text.has_substring (find_text) then
				if not replacement_text.is_valid_as_string_8 then
					set_utf_encoding (8)
				end
				Precursor
			end
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [TP_PATTERN]
		do
			create Result.make_from_array (<< string_literal (find_text) |to| agent replace (?, ?, replacement_text)>>)
		end

feature {NONE} -- Implementation

	find_text: ZSTRING

	replacement_text: ZSTRING
end