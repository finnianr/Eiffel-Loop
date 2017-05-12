note
	description: "[
		Performs a http download using the connection `connection' and storing the
		data in the supplied `file_path' argument
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 12:14:49 GMT (Thursday 11th May 2017)"
	revision: "3"

class
	EL_SAVED_HTTP_GET_COMMAND

inherit
	EL_HTTP_DOWNLOAD_COMMAND
		rename
			make as make_command
		redefine
			execute, prepare
		end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_file_path: like file_path)
		do
			make_command
			file_path := a_file_path
			create file_out.make_with_path (file_path)
		end

feature -- Basic operations

	execute (connection: EL_HTTP_CONNECTION)
		do
			file_path := file_out.path
			File_system.make_directory (file_path.parent)
			file_out.open_write
			Precursor (connection)
			file_out.close
		end

feature {NONE} -- Implementation

	on_string_transfer (a_string: STRING)
		do
			file_out.put_string (a_string)
		end

	prepare (connection: EL_HTTP_CONNECTION)
		do
			connection.enable_get_method
			Precursor (connection)
		end

feature {NONE} -- Internal attributes

	file_out: RAW_FILE

	file_path: EL_FILE_PATH

end
