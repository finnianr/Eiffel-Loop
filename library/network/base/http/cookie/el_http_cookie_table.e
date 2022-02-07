note
	description: "Parses HTTP cookies from cookie file creating a table of name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 5:55:25 GMT (Monday 7th February 2022)"
	revision: "13"

class
	EL_HTTP_COOKIE_TABLE

inherit
	HASH_TABLE [ZSTRING, STRING]
		redefine
			default_create
		end

	EL_STRING_STATE_MACHINE [STRING_8]
		rename
			make as make_machine,
			traverse as do_with_lines,
			item_number as line_number
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_FILE

create
	make_from_file, default_create

feature {NONE} -- Initialization

	default_create
		do
			make_machine
			make (1)
		end

	make_from_file (a_file_path: FILE_PATH)
		do
			make_machine
			if attached File.plain_text_lines (a_file_path) as lines then
				make (lines.count)
				do_with_split (agent find_first_cookie, lines, False)
			end
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
			tab_splitter: EL_SPLIT_ON_CHARACTER [STRING]; value: ZSTRING; cookie_value: EL_COOKIE_STRING_8
			name: STRING
		do
			create tab_splitter.make (line, '%T')
			across tab_splitter as split loop
				inspect split.cursor_index
					when 6 then
						name := split.item_copy
					when 7 then
						cookie_value := split.item
						value := cookie_value.decoded
						if value.has_quotes (2) then
							value.remove_quotes
						end
						put (value, name)
				else
				end
			end
		end

feature {NONE} -- Constants

	Comment_start: STRING = "# "

end