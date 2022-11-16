note
	description: "Match beginning of line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 15:37:23 GMT (Wednesday 16th November 2022)"
	revision: "7"

class
	EL_BEGINNING_OF_LINE_TP

inherit
	EL_TEXT_PATTERN
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_is_new_line (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i] = '%N'
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		do
			if not (a_offset = 0 or else i_th_is_new_line (a_offset, text)) then
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := a_offset = 0 or else i_th_is_new_line (a_offset, text)
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "start_of_line"
		end
end