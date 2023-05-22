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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 15:12:37 GMT (Sunday 21st May 2023)"
	revision: "26"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STRING_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			traverse_iterable as do_with_iterable_lines,
			item_number as line_number
		redefine
			call
		end

	EL_FILE_OPEN_ROUTINES

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_FILE_GENERAL_LINE_SOURCE [ZSTRING])
		do
			do_with_lines (initial, lines)
			lines.close
		end

feature -- Status query

	left_adjusted: BOOLEAN
		-- when `True' left adjusts line before calling `state'

feature {NONE} -- Implementation

	call (item: ZSTRING)
		-- call state procedure with item
		local
			item_count: INTEGER
		do
			if left_adjusted then
				item_count := item.count
				item.left_adjust
				left_count := item_count - item.count
			else
				left_count := 0
			end
			state (item)
		end

	left_count: INTEGER
		-- count of characters removed by `item.left_adjust' if `left_adjusted' is True
end