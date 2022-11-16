note
	description: "Matches end of line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_END_OF_LINE_CHAR_TP

inherit
	EL_LITERAL_CHAR_TP
		rename
			make as make_with_character,
			make_with_action as make_literal_with_action
		redefine
			match_count, meets_definition, name_inserts, Name_template
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_with_character ('%N')
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		do
			if a_offset = text.count then
				Result := 0
			else
				Result := Precursor (a_offset, text)
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := a_offset = text.count or else i_th_matches (a_offset + 1, text)
		end

	name_inserts: TUPLE
		do
			create Result
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "EOL"
		end
end