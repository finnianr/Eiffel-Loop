note
	description: "Literal text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:31:28 GMT (Friday 28th October 2022)"
	revision: "1"

class
	EL_LITERAL_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN
		redefine
			match_count
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_GENERAL)
			--
		do
			make_default
			set_text (a_text)
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; source_text: like new_text): INTEGER
			--
		local
			text_count: INTEGER
		do
			text_count := text.count
			if (source_text.count - a_offset) >= text_count
				and then same_characters (source_text, a_offset, text_count)
			then
				Result := text_count
			else
				Result := Match_fail
			end
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
			--
		do
			text := new_text (a_text)
		end

feature -- Access

	name: STRING
		do
			Result := "''"
			Result.insert_string (text.to_string_8, 2)
		end

	text: like new_text

feature {NONE} -- Implementation

	same_characters (source_text: like new_text; a_offset, text_count: INTEGER): BOOLEAN
		do
			Result := text.same_characters (source_text, a_offset + 1, a_offset + text_count, 1)
		end

	new_text (a_text: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			Result := a_text
		end

end