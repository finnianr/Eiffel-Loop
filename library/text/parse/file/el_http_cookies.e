note
	description: "Summary description for {EL_HTTP_COOKIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_HTTP_COOKIES

inherit
	HASH_TABLE [EL_ASTRING, EL_ASTRING]
		redefine
			default_create
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			default_create, is_equal, copy
		end

create
	make_from_file, default_create

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			lines: EL_FILE_LINE_SOURCE
		do
			make (7)
			create lines.make (a_file_path)
			do_with_lines (agent find_first_cookie, lines)
		end

	default_create
		do
			make (1)
		end

feature {NONE} -- State handlers

	find_first_cookie (line: EL_ASTRING)
		do
			if not (line.is_empty or line.starts_with ("# ")) then
				state := agent parse_cookie
				parse_cookie (line)
			end
		end

	parse_cookie (line: EL_ASTRING)
		local
			fields: LIST [EL_ASTRING]
		do
			fields := line.split ('%T')
			if fields.count = 7 then
				put (fields [7], fields [6])
			end
		end

end