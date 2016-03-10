note
	description: "Summary description for {EL_NETWORK_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_NETWORK_STREAM_SOCKET

inherit
	NETWORK_STREAM_SOCKET
		rename
			put_string as put_string_8
		undefine
			read_stream, readstream
		redefine
			make
		end

	EL_STREAM_SOCKET

create
	make_client_by_port, make_server_by_port

feature -- Initialization

	make
		do
			Precursor
			set_latin_1_encoding
		end

feature -- Status query

	is_client_connected: BOOLEAN
			--
		do
			if attached {like Current} accepted as client then
				Result := true
			end
		end

end
