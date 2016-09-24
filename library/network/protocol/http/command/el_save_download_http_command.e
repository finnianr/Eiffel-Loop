note
	description: "[
		Performs a http download using the connection `connection' and storing the
		data in the supplied `file_path' argument
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-21 9:31:15 GMT (Wednesday 21st September 2016)"
	revision: "1"

class
	EL_SAVE_DOWNLOAD_HTTP_COMMAND

inherit
	EL_DOWNLOAD_HTTP_COMMAND
		rename
			make as make_command
		redefine
			execute
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_connection: like connection; file_path: EL_FILE_PATH)
		do
			make_command (a_connection)
			File_system.make_directory (file_path.parent)
			create file_out.make_open_write (file_path)
		end

feature -- Basic operations

	execute
		do
			Precursor
			file_out.close
		end

feature {NONE} -- Implementation

	file_out: RAW_FILE

	on_string_transfer (a_string: STRING)
		do
			file_out.put_string (a_string)
		end

end
