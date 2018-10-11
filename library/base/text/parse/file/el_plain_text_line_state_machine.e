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
	date: "2017-12-14 13:03:24 GMT (Thursday 14th December 2017)"
	revision: "5"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			item_number as line_number
		redefine
			call
		end

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_LINE_SOURCE [FILE])
		do
			do_with_lines (initial, lines)
			lines.close
		end

feature {NONE} -- Implementation

	begins (line: ZSTRING; str: READABLE_STRING_GENERAL): BOOLEAN
		-- True if left-adjusted `line' starts with `str'
		local
			white_count: INTEGER
		do
			white_count := line.leading_white_space
			if line.count - white_count >= str.count then
				Result := line.same_characters (str, 1, str.count, white_count + 1)
			end
		end

	ends_with_character (line: ZSTRING; c: CHARACTER_32): BOOLEAN
		do
			if not line.is_empty then
				Result := line [line.count] = c
			end
		end

	call (item: ZSTRING)
		-- call state procedure with item
		do
			tuple.put_reference (item, 1)
			state.set_operands (tuple)
			state.apply
		end
end
