note
	description: "A faux Unix stream socket to compile Unix-only sub-applications on Windows"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 15:03:19 GMT (Monday 27th January 2020)"
	revision: "10"

class
	EL_UNIX_STREAM_SOCKET

inherit
	EL_NETWORK_STREAM_SOCKET

create
	make, make_client, make_server

feature {NONE} -- Initialization

	make_client (path: EL_FILE_PATH)
		do
			socket_path := path
			is_server := False
			make_default
		end

	make_server (path: EL_FILE_PATH)
		do
			socket_path := path
			is_server := True
			make_default
		end

	socket_path: EL_FILE_PATH

feature -- Status query

	is_server: BOOLEAN

invariant
	cannot_be_used_on_mswin: False
end
