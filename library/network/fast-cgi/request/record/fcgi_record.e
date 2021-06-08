note
	description: "Base class for reading and writing a Fast-CGI record"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-08 9:42:50 GMT (Tuesday 8th June 2021)"
	revision: "4"

deferred class
	FCGI_RECORD

inherit
	FCGI_CONSTANTS

feature -- Basic operations

	read (broker: FCGI_REQUEST_BROKER)
		local
			memory: like Memory_reader_writer
		do
			set_padding_and_byte_count (broker.Header)
			memory := Memory_reader_writer
			memory.set_for_writing
			memory.reset_count
			memory.write_bytes_from_medium (broker.socket, byte_count + padding_count)

			if broker.read_ok then
				if is_last (broker.Header) then
					on_last_read (broker)
				else
					memory.set_for_reading
					memory.reset_count
					read_memory (memory)
					memory.read_skip (reserved_count)
					check
						valid_count: Memory_reader_writer.count = byte_count
					end
					on_data_read (broker)
				end
			end
		end

	write (broker: FCGI_REQUEST_BROKER)
		do
			set_padding_and_byte_count (broker.Header)
			write_socket (broker.socket)
		end

feature -- Access

	byte_count: INTEGER

	padding_count: INTEGER

	reserved_count: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	is_last (header: FCGI_HEADER_RECORD): BOOLEAN
		-- `True' if previous record was the last in a series.
		-- Applies specifically to reading a series of `FCGI_STRING_CONTENT_RECORD' or `FCGI_PARAMETER_RECORD'
		do
		end

	on_data_read (broker: FCGI_REQUEST_BROKER)
		deferred
		end

	on_last_read (broker: FCGI_REQUEST_BROKER)
		do
		end

	read_memory (memory: FCGI_MEMORY_READER_WRITER)
		require
			readable: memory.is_for_reading
			is_reset: memory.count = 0
		deferred
		end

	set_padding_and_byte_count (header: FCGI_HEADER_RECORD)
		do
			byte_count := Fcgi_header_len
			padding_count := 0
		end

	write_memory (memory: FCGI_MEMORY_READER_WRITER)
		require
			readable: memory.is_ready_for_writing
			is_reset: memory.count = 0
		deferred
		end

	write_socket (socket: EL_STREAM_SOCKET)
		local
			memory: like Memory_reader_writer; i: INTEGER
		do
			memory := Memory_reader_writer

			memory.set_for_writing
			memory.reset_count
			write_memory (memory)
			memory.write_bytes (0, reserved_count)
			check
				valid_count: memory.count = byte_count
			end
			from i := 1 until i > padding_count loop
				memory.write_character_8 (' ')
				i := i + 1
			end
			memory.write_to_medium (socket)
		end

feature {NONE} -- Constants

	Memory_reader_writer: FCGI_MEMORY_READER_WRITER
		once
			create Result.make
		end

end