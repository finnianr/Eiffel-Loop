note
	description: "[
		`FCGI_STDIN' is a stream record type used in sending arbitrary data from the Web server
		to the application. `FCGI_DATA' is a second stream record type used to send additional
		data to the application.

		`FCGI_STDOUT' and `FCGI_STDERR' are stream record types for sending arbitrary data and error
		data respectively from the application to the Web server.

		See: [https://fast-cgi.github.io/spec#53-byte-streams-fcgi_stdin-fcgi_data-fcgi_stdout-fcgi_stderr]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	FCGI_STRING_CONTENT_RECORD

inherit
	FCGI_RECORD
		redefine
			default_create, set_padding_and_byte_count, is_last, on_last_read
		end

	STRING_HANDLER
		undefine
			default_create
		end

	EL_ZSTRING_CONSTANTS

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create content.make_empty
		end

feature -- Access

	content: STRING

feature {NONE} -- Implementation

	is_last (header: FCGI_HEADER_RECORD): BOOLEAN
		-- `True' if previous record was the last in a series.
		-- Applies specifically to reading a series of `FCGI_STRING_CONTENT_RECORD' or `FCGI_PARAMETER_RECORD'
		do
			Result := header.content_length = 0
		end

	on_data_read (broker: FCGI_REQUEST_BROKER)
		do
			broker.on_stdin_request (Current)
		end

	on_last_read (broker: FCGI_REQUEST_BROKER)
		do
			broker.on_stdin_request_last
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		do
			read_content (memory, byte_count)
		end

	set_padding_and_byte_count (header: FCGI_HEADER_RECORD)
		do
			byte_count := header.content_length
			padding_count := header.padding_length
		end

	read_content (memory: FCGI_MEMORY_READER_WRITER; count: INTEGER)
		do
			memory.read_to_string_8 (content, count)
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		require else
			valid_byte_count: (offset + byte_count) <= content.count
		do
			memory.write_sub_special (content.area, offset, byte_count)
		end

feature {NONE} -- Internal attributes

	offset: INTEGER
		-- zero based content offset

feature {NONE} -- Constants

	Reserved_count: INTEGER = 0

end