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
	date: "2020-12-20 10:21:57 GMT (Sunday 20th December 2020)"
	revision: "15"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			traverse_iterable as do_with_iterable_lines,
			item_number as line_number
		end

	EL_FILE_OPEN_ROUTINES

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