note
	description: "Literal text pattern for text of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:57:24 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_LITERAL_TP

inherit
	EL_LITERAL_TEXT_PATTERN
		redefine
			same_characters, new_text
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

create
	make

feature {NONE} -- Implementation

	same_characters (source_text: ZSTRING; a_offset, text_count: INTEGER): BOOLEAN
		do
			Result := text.same_characters (source_text, a_offset + 1, a_offset + text_count, 1)
		end

	new_text (a_text: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (a_text)
		end

end