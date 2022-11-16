note
	description: "Literal text pattern for source text conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_8_LITERAL_TP

inherit
	EL_LITERAL_TEXT_PATTERN
		redefine
			same_characters, new_text
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

create
	make

feature {NONE} -- Implementation

	same_characters (source_text: READABLE_STRING_8; a_offset, text_count: INTEGER): BOOLEAN
		do
			Result := text.same_characters (source_text, a_offset + 1, a_offset + text_count, 1)
		end

	new_text (a_text: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			Result := a_text.to_string_8
		end

end