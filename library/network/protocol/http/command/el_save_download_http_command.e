note
	description: "[
		Performs a http download using the connection `connection' and storing the
		data in the supplied `file_path' argument
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-28 7:55:51 GMT (Wednesday 28th September 2016)"
	revision: "2"

class
	EL_SAVE_DOWNLOAD_HTTP_COMMAND

inherit
	EL_DOWNLOAD_HTTP_COMMAND
		rename
			execute as execute_command
		redefine
			make
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create file_out.make_with_name ("none")
		end

feature -- Basic operations

	execute (connection: EL_HTTP_CONNECTION; file_path: EL_FILE_PATH)
		do
			File_system.make_directory (file_path.parent)
			create file_out.make_open_write (file_path)
			execute_command (connection)
			file_out.close
		end

feature {NONE} -- Implementation

	file_out: RAW_FILE

	on_string_transfer (a_string: STRING)
		do
			file_out.put_string (a_string)
		end

end
