note
	description: "Summary description for {EL_PLAIN_TEXT_LINE_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [EL_ASTRING]
		rename
			traverse as do_with_lines
		redefine
			do_with_lines
		end

feature -- Basic operations

	do_with_lines (initial: like state; lines: LINEAR [EL_ASTRING])
			--
		do
			Precursor (initial, lines)
			if attached {EL_FILE_LINE_SOURCE} lines as file_lines
				and then file_lines.is_open
			then
				file_lines.close
			end
		end

end