note
	description: "[
		The application sends a `FCGI_END_REQUEST' record to terminate a request,
		either because the application has processed the request or because
		the application has rejected the request.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 16:21:49 GMT (Friday 2nd March 2018)"
	revision: "4"

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
