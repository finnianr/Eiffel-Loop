note
	description: "Matches quoted string with escaping for Eiffel language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 16:43:49 GMT (Sunday 12th November 2023)"
	revision: "4"

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
				across String_32_scope as scope loop
					if attached scope.substring_item (text, start_index + 2, end_index - 1) as str then
						Result := str.to_natural
					end
				end
			end
		end

end
