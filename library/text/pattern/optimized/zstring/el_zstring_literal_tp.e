note
	description: "Literal text pattern for text of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:22:20 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_ZSTRING_LITERAL_TP

inherit
	EL_LITERAL_TEXT_PATTERN
		redefine
			same_characters, new_text
		end

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