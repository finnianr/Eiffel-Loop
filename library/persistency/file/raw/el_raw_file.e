note
	description: "Summary description for {EL_RAW_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-26 10:16:19 GMT (Friday 26th June 2015)"
	revision: "4"

class
	EL_RAW_FILE

inherit
	EL_FILE
		rename
			index as position
		undefine
			read_to_managed_pointer, file_open, file_dopen, file_reopen
		end

	RAW_FILE
		rename
			copy_to as copy_to_file
		end

create
	make, make_with_name, make_with_path,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature {NONE} -- Factory

	new_file (file_path: EL_FILE_PATH): like Current
		do
			create Result.make_with_name (file_path)
		end
end
