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
	date: "2018-11-14 10:08:45 GMT (Wednesday 14th November 2018)"
	revision: "8"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			item_number as line_number
		undefine
			set_operands
		end

	EL_ROUTINE_REFERENCE_APPLICATOR [ZSTRING]
		undefine
			make
		end

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_LINE_SOURCE [FILE])
		do
			do_with_lines (initial, lines)
			lines.close
		end

end
