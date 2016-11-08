note
	description: "Parses HTTP cookies from cookie file creating a table of name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-28 9:04:52 GMT (Wednesday 28th September 2016)"
	revision: "3"

class
	EL_HTTP_COOKIES

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
		undefine
			default_create, is_equal, copy
		end

	KL_IMPORTED_INTEGER_ROUTINES
		rename
			Integer_ as Integer
		undefine
			default_create, is_equal, copy
		end

	OCTAL_UTILS
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

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
			fields: LIST [STRING]; value: ZSTRING
		do
			fields := line.split ('%T')
			if fields.count = 7 then
				value := decoded (fields [7])
				if value.has_quotes (2) then
					value.remove_quotes
				end
				put (value, fields.i_th (6))
			end
		end

feature {NONE} -- Implementation

	decoded (value: STRING): ZSTRING
		-- decode utf-8 encoded strings like "K\303\266ln-Altstadt-S\303\274d"
		local
			i: INTEGER; utf_8, digits: STRING; c: CHARACTER
			is_escaped: BOOLEAN
		do
			create utf_8.make (value.count)
			from i := 1 until i > value.count loop
				c := value [i]
				if c = '\' and then (i + 3) <= value.count then
					digits := value.substring (i + 1, i + 3)
					is_escaped := digits.is_natural
				else
					is_escaped := False
				end
				if is_escaped then
					utf_8.append_code (octal_string_to_natural_32 (digits))
					i := i + 4
				else
					utf_8.append_character (c)
					i := i + 1
				end
			end
			create Result.make_from_utf_8 (utf_8)
		end

feature {NONE} -- Constants

	Comment_start: STRING = "# "

end
