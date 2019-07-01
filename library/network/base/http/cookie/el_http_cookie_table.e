note
	description: "Parses HTTP cookies from cookie file creating a table of name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_HTTP_COOKIE_TABLE

inherit
	HASH_TABLE [ZSTRING, STRING]
		redefine
			default_create
		end

	EL_STATE_MACHINE [STRING_8]
		rename
			make as make_machine,
			traverse as do_with_lines,
			item_number as line_number
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_FILE_SYSTEM

create
	make_from_file, default_create

feature {NONE} -- Initialization

	default_create
		do
			make_machine
			make (1)
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			lines: LIST [STRING]
		do
			make_machine
			lines := File_system.plain_text (a_file_path).split ('%N')
			make (lines.count)
			do_with_lines (agent find_first_cookie, lines)
		end

feature {NONE} -- State handlers

	find_first_cookie (line: STRING)
		do
			if not (line.is_empty or line.starts_with (Comment_start)) then
				state := agent parse_cookie
				parse_cookie (line)
			end
		end

	parse_cookie (line: STRING)
		local
			fields: LIST [STRING]; value: ZSTRING; cookie_value: EL_COOKIE_STRING_8
		do
			fields := line.split ('%T')
			if fields.count = 7 then
				cookie_value := fields [7]
				value := cookie_value.to_string
				if value.has_quotes (2) then
					value.remove_quotes
				end
				put (value, fields.i_th (6))
			end
		end

feature {NONE} -- Constants

	Comment_start: STRING = "# "

end
