note
	description: "Matches end of line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:29:46 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_END_OF_LINE_CHAR

inherit
	TP_CHARACTER_PROPERTY
		rename
			i_th_matches as i_th_is_newline
		redefine
			match_count, meets_definition, name_inserts, Name_template
		end

feature {NONE} -- Implementation

	i_th_is_newline (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i] = '%N'
		end

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
			Result := a_offset = text.count or else i_th_is_newline (a_offset + 1, text)
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