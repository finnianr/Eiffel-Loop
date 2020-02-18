note
	description: "[
		A state machine for processing lines from a line source, using a line processing procedure
		defined by the attribute:
		
			state: PROCEDURE [ZSTRING]
			
		The line processing state can be changed by assigning a new procedure to `state'.
		Line processing stops either when `state' is assigned the procedure `final' or the last line
		in the line source is reached.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 20:31:04 GMT (Tuesday 18th February 2020)"
	revision: "13"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			item_number as line_number
		end

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_FILE_LINE_SOURCE)
		do
			do_with_lines (initial, lines)
			lines.close
		end

	do_with_split_list (initial: like state; lines: EL_SPLIT_ZSTRING_LIST; keep_ref: BOOLEAN)
		local
			l_final: like final
		do
			line_number := 0; l_final := final
			from lines.start; state := initial until lines.after or state = l_final loop
				line_number := line_number + 1
				call (lines.item (keep_ref))
				lines.forth
			end
		end

end
