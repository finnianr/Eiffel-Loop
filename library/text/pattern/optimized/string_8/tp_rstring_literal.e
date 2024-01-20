note
	description: "Literal text pattern for source text conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TP_RSTRING_LITERAL

inherit
	TP_LITERAL_PATTERN
		redefine
			same_characters, new_text
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

create
	make

feature {NONE} -- Implementation

	same_characters (source_text: READABLE_STRING_8; a_offset, text_count: INTEGER): BOOLEAN
		do
			if is_caseless then
				Result := text.same_caseless_characters (source_text, a_offset + 1, a_offset + text_count, 1)
			else
				Result := text.same_characters (source_text, a_offset + 1, a_offset + text_count, 1)
			end
		end

	new_text (a_text: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			Result := a_text.to_string_8
		end

end
