note
	description: "Notifying plain text file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_NOTIFYING_PLAIN_TEXT_FILE

inherit
	EL_NOTIFYING_FILE
		rename
			index as position
		undefine
			is_plain_text
		end

	PLAIN_TEXT_FILE
		undefine
			make_with_name, open_read, open_write, close, move, go, recede, back, start, finish, forth
		end

create
	make_closed, make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature -- Initialization

	make_closed
		do
			make_with_name ("None.txt")
		end

end