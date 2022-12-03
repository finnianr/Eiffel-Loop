note
	description: "[
		Match quoted character with escaping for Eiffel language and optimized for
		strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:26:57 GMT (Saturday 3rd December 2022)"
	revision: "4"

class
	TP_RSTRING_EIFFEL_QUOTED_CHAR

inherit
	TP_QUOTED_CHAR
		undefine
			core, i_th_is_single_quote
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

	TP_EIFFEL_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		local
			code: NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index]].to_character_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/' then
				code := core.copied_substring (text, start_index + 2, end_index - 1).to_natural
				Result := code.to_character_32
			end
		end

end

