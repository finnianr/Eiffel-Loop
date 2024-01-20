note
	description: "[
		${TP_ZSTRING_QUOTED_STRING} implemented for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	TP_ZSTRING_QUOTED_EIFFEL_STRING

inherit
	TP_ZSTRING_QUOTED_STRING

	TP_OPTIMIZED_FOR_ZSTRING

	TP_EIFFEL_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Codec.as_z_code (Code_table [text.item_8 (end_index)].to_character_32)

			elseif text.item_8 (start_index + 1) = '/' and then text.item_8 (end_index) = '/' then
				Result := core.copied_substring (text, start_index + 2, end_index - 1).to_natural
			end
		end

end

