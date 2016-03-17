note
	description: "Summary description for {EL_NOTIFYING_RAW_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-01 9:45:09 GMT (Friday 1st January 2016)"
	revision: "5"

class
	EL_NOTIFYING_RAW_FILE

inherit
	EL_NOTIFYING_FILE
		rename
			index as position,
			copy_to as copy_to_file
		undefine
			file_reopen, file_open, file_dopen, read_to_managed_pointer
		end

	EL_RAW_FILE
		undefine
			make_with_name, open_read, open_write, close, move, go, recede, back, start, finish, forth
		end

create
	make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

end
