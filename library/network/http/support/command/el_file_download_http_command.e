note
	description: "[
		Performs a http download using the connection `connection' and storing the
		data in the supplied `file_path' argument
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	EL_FILE_DOWNLOAD_HTTP_COMMAND

inherit
	EL_DOWNLOAD_HTTP_COMMAND
		rename
			make as make_command
		redefine
			execute, prepare
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_connection: like connection; a_file_path: like file_path)
		do
			make_command (a_connection)
			file_path := a_file_path
			create file_out.make_with_path (file_path)
		end

feature -- Basic operations

	execute
		do
			file_path := file_out.path
			File_system.make_directory (file_path.parent)
			file_out.open_write
			Precursor
			file_out.close
		end

feature {NONE} -- Implementation

	on_string_transfer (a_string: STRING)
		do
			file_out.put_string (a_string)
		end

	prepare
		do
			connection.enable_get_method
			Precursor
		end

feature {NONE} -- Internal attributes

	file_out: RAW_FILE

	file_path: FILE_PATH

end
