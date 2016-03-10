note
	description: "Summary description for {EL_PLAIN_TEXT_LINE_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ASTRING]
		rename
			traverse as do_with_lines
		end

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_LINE_SOURCE [FILE])
		do
			do_with_lines (initial, lines)
			lines.close
		end

end
