note
	description: "[
		Match quoted character with escaping for Eiffel language and optimized for
		strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 10:13:12 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_STRING_8_EIFFEL_QUOTED_CHARACTER_TP

inherit
	EL_MATCH_QUOTED_CHARACTER_TP
		redefine
			i_th_is_single_quote
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		local
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index]].to_character_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/'
				and then attached buffer.empty as str
			then
				str.append_substring (text, start_index + 2, end_index - 1)
				Result := str.to_natural.to_character_32
			end
		end

	i_th_is_single_quote (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = '%''
		end

end