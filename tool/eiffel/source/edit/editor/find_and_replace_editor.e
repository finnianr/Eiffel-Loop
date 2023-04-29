note
	description: "Find and replace editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 10:54:29 GMT (Saturday 29th April 2023)"
	revision: "13"

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

	make (a_find_text, a_replacement_text: READABLE_STRING_GENERAL)
			--
		do
			create find_text.make_from_general (a_find_text)
			create replacement_text.make_from_general (a_replacement_text)
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