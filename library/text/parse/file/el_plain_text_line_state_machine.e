note
	description: "Summary description for {EL_PLAIN_TEXT_LINE_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:27:25 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines
		end

feature -- Basic operations

	do_once_with_file_lines (initial: like state; lines: EL_LINE_SOURCE [FILE])
		do
			do_with_lines (initial, lines)
			lines.close
		end

feature -- Access

	colon_name (line: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 then
				Result := line.substring (1, pos_colon - 1)
			else
				create Result.make_empty
			end
		end

	colon_value (line: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 and then pos_colon + 2 <= line.count then
				Result := line.substring (pos_colon + 2, line.count)
			else
				create Result.make_empty
			end
		end

end
