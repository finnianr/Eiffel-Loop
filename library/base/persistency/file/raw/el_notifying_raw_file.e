note
	description: "Summary description for {EL_NOTIFYING_RAW_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_NOTIFYING_RAW_FILE

inherit
	EL_NOTIFYING_FILE
		rename
			index as position
		undefine
			file_reopen, file_open, file_dopen, read_to_managed_pointer
		end

	RAW_FILE
		undefine
			make_with_name, open_read, open_write, close, move, go, recede, back, start, finish, forth
		end

create
	make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

end