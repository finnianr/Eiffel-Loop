note
	description: "Matches quoted string with escaping for Eiffel language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 18:26:17 GMT (Tuesday 5th November 2024)"
	revision: "5"

class
	TP_QUOTED_EIFFEL_STRING

inherit
	TP_QUOTED_STRING

	TP_EIFFEL_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index].to_character_8].to_natural_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/' then
				if attached String_32_pool.borrowed_item as borrowed then
					if attached borrowed.copied_substring_general (text, start_index + 2, end_index - 1) as str then
						Result := str.to_natural
					end
					borrowed.return
				end
			end
		end

end