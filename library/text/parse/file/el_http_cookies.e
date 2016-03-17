note
	description: "Summary description for {EL_HTTP_COOKIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:58:23 GMT (Sunday 20th December 2015)"
	revision: "6"

class
	EL_HTTP_COOKIES

inherit
	HASH_TABLE [ZSTRING, STRING]
		redefine
			default_create
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
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
			make_machine
			make (7)
			create lines.make (a_file_path)
			do_once_with_file_lines (agent find_first_cookie, lines)
		end

	default_create
		do
			make_machine
			make (1)
		end

feature {NONE} -- State handlers

	find_first_cookie (line: ZSTRING)
		do
			if not (line.is_empty or line.starts_with (Comment_start)) then
				state := agent parse_cookie
				parse_cookie (line)
			end
		end

	parse_cookie (line: ZSTRING)
		local
			fields: LIST [ZSTRING]
		do
			fields := line.split ('%T')
			if fields.count = 7 then
				put (fields [7], fields.i_th (6).to_latin_1)
			end
		end

feature {NONE} -- Constants

	Comment_start: ZSTRING
		once
			Result := "# "
		end

end
