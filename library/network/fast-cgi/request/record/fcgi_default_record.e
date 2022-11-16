note
	description: "Default record indicating unknown request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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