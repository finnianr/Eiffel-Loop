note
	description: "Default record indicating unknown request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-11 16:49:38 GMT (Wednesday 11th December 2019)"
	revision: "4"

class
	FCGI_DEFAULT_RECORD

inherit
	FCGI_RECORD

feature {NONE} -- Implementation

	on_data_read (broker: FCGI_REQUEST_BROKER)
		do
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
		end

feature {NONE} -- Constants

	Reserved_count: INTEGER = 5

end
