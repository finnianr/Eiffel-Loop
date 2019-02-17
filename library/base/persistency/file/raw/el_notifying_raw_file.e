note
	description: "Notifying raw file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-16 12:23:59 GMT (Saturday 16th February 2019)"
	revision: "7"

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
			close, move, go, recede, back, start, finish, forth
		end

create
	make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

end
