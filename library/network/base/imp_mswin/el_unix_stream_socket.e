note
	description: "A faux Unix stream socket to compile Unix-only sub-applications on Windows"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "11"

class
	EL_UNIX_STREAM_SOCKET

inherit
	EL_NETWORK_STREAM_SOCKET

create
	make, make_client, make_server

feature {NONE} -- Initialization

	make_client (path: FILE_PATH)
		do
			socket_path := path
			is_server := False
			make_default
		end

	make_server (path: FILE_PATH)
		do
			socket_path := path
			is_server := True
			make_default
		end

	socket_path: FILE_PATH

feature -- Status query

	is_server: BOOLEAN

invariant
	cannot_be_used_on_mswin: False
end
