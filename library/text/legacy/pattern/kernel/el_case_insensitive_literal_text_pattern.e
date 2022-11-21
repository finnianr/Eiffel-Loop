note
	description: "Case insensitive literal text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_CASE_INSENSITIVE_LITERAL_TEXT_PATTERN

inherit
	EL_LITERAL_TEXT_PATTERN
		redefine
			match_count
		end

create
	make_from_string

feature {NONE} -- Implementation

	match_count (a_text: EL_STRING_VIEW): INTEGER
			--
		local
			l_text: STRING_32; buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			l_text := buffer.empty
			a_text.append_substring_to (l_text, 1, text.count)
			if l_text.same_caseless_characters_general (text, 1, text.count, 1) then
				Result := text.count
			else
				Result := Match_fail
			end
		end

end