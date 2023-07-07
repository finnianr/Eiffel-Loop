note
	description: "[
		Performs a http download using the connection `connection' and storing the
		data in the supplied `file_path' argument
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 8:57:19 GMT (Friday 7th July 2023)"
	revision: "7"

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

	make (a_connection: like connection; a_file_path: FILE_PATH)
		do
			make_command (a_connection)
			create file_out.make_with_name (a_file_path)
		end

feature -- Access

	file_path: FILE_PATH
		do
			Result := file_out.path
		end

feature -- Basic operations

	execute
		do
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

end