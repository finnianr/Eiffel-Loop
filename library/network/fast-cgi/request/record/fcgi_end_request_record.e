note
	description: "[
		The application sends a `FCGI_END_REQUEST' record to terminate a request, either because the
		application has processed the request or because the application has rejected the request.

		The contentData component of a `FCGI_END_REQUEST' record has the form:

			typedef struct {
				unsigned char appStatusB3;
				unsigned char appStatusB2;
				unsigned char appStatusB1;
				unsigned char appStatusB0;
				unsigned char protocolStatus;
				unsigned char reserved[3];
			} FCGI_EndRequestBody;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-27 17:51:19 GMT (Tuesday 27th February 2018)"
	revision: "3"

class
	FCGI_END_REQUEST_RECORD

inherit
	FCGI_RECORD
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			app_status := Fcgi_request_complete.as_natural_32
		end

feature -- Access

	app_status: NATURAL

	protocol_status: NATURAL_8

feature {NONE} -- Implementation

	on_data_read (request: FCGI_REQUEST_BROKER)
		do
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			app_status := memory.read_natural_32
			protocol_status := memory.read_natural_8
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			 memory.write_natural_32 (app_status)
			 memory.write_natural_8 (protocol_status)
		end

feature {NONE} -- Constants

	Reserved_count: INTEGER = 3

end
