note
	description: "Summary description for {FCGI_END_SERVICE_RECORD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-19 15:15:04 GMT (Friday 19th January 2018)"
	revision: "2"

class
	FCGI_END_SERVICE_RECORD

inherit
	FCGI_HEADER_RECORD
		rename
			write as write_request
		export
			{NONE} read, write_request
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			version := 1
			request_id := Fcgi_default_request_id
			type := Fcgi_end_service.to_natural_8
			byte_count := Fcgi_header_len
		end

feature -- Basic operations

	write (socket: EL_NETWORK_STREAM_SOCKET)
		local
			memory: like Memory_reader_writer
		do
			memory := Memory_reader_writer
			memory.set_for_writing
			memory.reset_count
			write_memory (memory)
			memory.write_to (socket)
		end
end
