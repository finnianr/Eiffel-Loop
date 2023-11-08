note
	description: "[
		[$source TP_RSTRING_QUOTED_STRING] implemented for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 14:10:21 GMT (Wednesday 8th November 2023)"
	revision: "4"

class
	TP_RSTRING_QUOTED_EIFFEL_STRING

inherit
	TP_RSTRING_QUOTED_STRING
		redefine
			unescaped_code
		end

	TP_EIFFEL_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index]].to_natural_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/' then
				Result := core.copied_substring (text, start_index + 2, end_index - 1).to_natural
			end
		end

end

