note
	description: "[
		The application sends a FCGI_END_REQUEST record to terminate a request, either because the
		application has processed the request or because the application has rejected the request.

		The contentData component of a FCGI_END_REQUEST record has the form:

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
	date: "2018-02-05 10:43:51 GMT (Monday 5th February 2018)"
	revision: "2"

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
			create reserved.make_filled (0, 1, 3)
		end

feature -- Access

	protocol_status: NATURAL_8

	reserved: ARRAY [NATURAL_8]

	app_status: NATURAL

feature {NONE} -- Implementation

	on_data_read (request: FCGI_REQUEST_BROKER)
		do
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			app_status := memory.read_natural_32
			protocol_status := memory.read_natural_8
			memory.read_to_natural_8_array (reserved)
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			 memory.write_natural_32 (app_status)
			 memory.write_natural_8 (protocol_status)
			 memory.write_natural_8_array (reserved)
		end

end
