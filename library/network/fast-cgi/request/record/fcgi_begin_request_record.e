note
	description: "[
		The Web server sends a `FCGI_BEGIN_REQUEST' record to start a request.
		The contentData component of a `FCGI_BEGIN_REQUEST' record has the form:

			typedef struct {
				unsigned char roleB1;
				unsigned char roleB0;
				unsigned char flags;
				unsigned char reserved[5];
			} FCGI_BeginRequestBody;
			
		See: [https://fast-cgi.github.io/spec#51-fcgi_begin_request]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	FCGI_BEGIN_REQUEST_RECORD

inherit
	FCGI_RECORD

feature -- Access

	flags: NATURAL_8

	role: NATURAL_16

feature {NONE} -- Implementation

	on_data_read (broker: FCGI_REQUEST_BROKER)
		do
			broker.on_begin_request (Current)
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			role := memory.read_natural_16
			flags := memory.read_natural_8
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			 memory.write_natural_16 (role)
			 memory.write_natural_8 (flags)
		end

feature {NONE} -- Constants

	Reserved_count: INTEGER = 5

end