note
	description: "Summary description for {EL_UNIX_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_UNIX_STREAM_SOCKET

inherit
	UNIX_STREAM_SOCKET
		rename
			put_string as put_encoded_string_8
		undefine
			read_stream, readstream
		redefine
			make_socket, create_from_descriptor
		end

	EL_STREAM_SOCKET
		undefine
			address_type, cleanup, name
		end

create
	make, make_client, make_server

feature -- Initialization

	create_from_descriptor (fd: INTEGER)
		do
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

feature -- Basic operations

	add_permission (who, what: STRING)
			-- Add read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		do
			Chmod_command.put_string (Var_path, address.path)
			Chmod_command.put_string (Var_permission, who + what)
			Chmod_command.execute
		end

feature {NONE} -- Constants

	Chmod_command: EL_OS_COMMAND
		once
			create Result.make ("chmod $permission $path")
		end

	Var_path: ZSTRING
		once
			Result := "path"
		end

	Var_permission: ZSTRING
		once
			Result := "permission"
		end

end
