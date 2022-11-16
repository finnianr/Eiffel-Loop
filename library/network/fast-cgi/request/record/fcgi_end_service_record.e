note
	description: "[
		The application sends a `FCGI_END_REQUEST' record to terminate a request,
		either because the application has processed the request or because
		the application has rejected the request.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	FCGI_END_SERVICE_RECORD

inherit
	FCGI_HEADER_RECORD
		rename
			write as broker_write,
			write_socket as write
		export
			{ANY} write
		end

create
	make

feature {FCGI_SEPARATE_SERVLET_SERVICE} -- Initialization

	make
		do
			set_fields (1, Fcgi_default_request_id, Fcgi_end_service, Fcgi_header_len, 0)
			byte_count := Fcgi_header_len
		end

end