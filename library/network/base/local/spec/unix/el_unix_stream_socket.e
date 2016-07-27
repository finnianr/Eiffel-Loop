note
	description: "Summary description for {EL_UNIX_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:29:57 GMT (Friday 18th December 2015)"
	revision: "4"

class
	EL_UNIX_STREAM_SOCKET

inherit
	UNIX_STREAM_SOCKET
		rename
			put_string as put_encoded_string_8
		undefine
			read_stream, readstream
		end

	EL_STREAM_SOCKET

create
	make_client, make_server

end