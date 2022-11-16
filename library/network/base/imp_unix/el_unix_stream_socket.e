note
	description: "Unix stream socket"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	EL_UNIX_STREAM_SOCKET

inherit
	UNIX_STREAM_SOCKET
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8,
			make_server as make_named_server,
			last_string as internal_last_string
		undefine
			read_stream, readstream, read_into_pointer, put_pointer_content
		redefine
			make_socket, create_from_descriptor, close_socket
		end

	EL_STREAM_SOCKET
		undefine
			address_type, cleanup, name
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_client, make_server

feature {NONE} -- Initialization

	make_server (path: FILE_PATH)
		do
			socket_path := path
			is_server := True
			delete_file
			make_named_server (path.to_string)
		end

feature -- Initialization

	create_from_descriptor (fd: INTEGER)
		do
			make_default
			is_blocking := True
			Precursor (fd)
		end

	make_socket
		do
			make_default
			Precursor
		end

feature -- Access

	description: STRING
		do
			Result := "UNIX socket " + address.path
		end

	socket_path: FILE_PATH

feature -- Status query

	is_server: BOOLEAN

feature -- Basic operations

	add_permission (who, what: STRING)
			-- Add read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		do
			Chmod_command.put_string (Var_path, address.path)
			Chmod_command.put_string (Var_permission, who + what)
			Chmod_command.execute
		end

	close_socket
		do
			Precursor
			if is_server then
				delete_file
			end
		end

feature {NONE} -- Implementation

	delete_file
		do
			if socket_path.exists then
				File_system.remove_file (socket_path)
			end
		end

feature {NONE} -- Constants

	Chmod_command: EL_OS_COMMAND
		once
			create Result.make ("chmod $permission $path")
		end

	Var_path: STRING = "path"

	Var_permission: STRING = "permission"

end