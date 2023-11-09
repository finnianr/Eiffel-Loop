note
	description: "Notifying plain text file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 17:25:26 GMT (Thursday 9th November 2023)"
	revision: "12"

class
	EL_NOTIFYING_PLAIN_TEXT_FILE

inherit
	EL_NOTIFYING_FILE
		rename
			index as position,
			path as ise_path,
			put_string as put_encoded_string_8,
			put_character as put_encoded_character_8,
			last_string as last_string_8,
			read_line as read_line_8
		undefine
			is_plain_text, make_with_path, make_with_name
		end

	EL_PLAIN_TEXT_FILE
		undefine
			open_read, open_write, close, move, go, recede, back, start, finish, forth
		end

create
	make_closed, make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

end