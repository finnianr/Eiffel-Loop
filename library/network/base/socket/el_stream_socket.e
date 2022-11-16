note
	description: "Encodeable stream with ability to read Ctrl-Z end delimited strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_STREAM_SOCKET

inherit
	STREAM_SOCKET
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8,
			last_string as internal_last_string
		export
			{NONE} internal_last_string
		redefine
			read_stream, readstream, put_pointer_content, read_into_pointer
		end

	EL_OUTPUT_MEDIUM
		redefine
			make_default
		end

	STRING_HANDLER

feature -- Initialization

	make_default
		do
			Precursor
			read_listener := Default_listener
			write_listener := Default_listener
		end

feature -- Access

	bytes_sent: INTEGER
		-- Last number of bytes put by `put_pointer_content'

	description: STRING
		deferred
		end

	last_string (keep_ref: BOOLEAN): STRING
		do
			Result := internal_last_string
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Input

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' characters.
			-- Make result available in `last_string'.
		require else
			socket_exists: exists;
			opened_for_read: is_open_read
		local
			count: INTEGER; l_area: SPECIAL [CHARACTER]
		do
			internal_last_string.grow (nb_char)
			l_area := internal_last_string.area
			count := c_read_stream (descriptor, nb_char, l_area.base_address)
			if count > 0 then
				internal_last_string.set_count (count)
				bytes_read := count
			else
				bytes_read := 0
				internal_last_string.wipe_out
			end
			read_listener.notify
		end

	read_string
			-- read string with end delimited by ctrl-z code (DEC 26)
		require else
			socket_exists: exists;
			opened_for_read: is_open_read
		local
			transmission_complete: BOOLEAN
			packet: like Packet_buffer; count: INTEGER
		do
			packet := Packet_buffer
			packet.set_count (Default_packet_size)
			internal_last_string.wipe_out
			from until transmission_complete loop
				count := c_read_stream (descriptor, packet.capacity, packet.base_address)
				if count > 0 then
					packet.set_count (count)
					packet.fill_string (internal_last_string)
					transmission_complete := packet.item (count) = End_of_string_delimiter_code
				else
					transmission_complete := true
				end
			end
			bytes_read := internal_last_string.count
			read_listener.notify
			internal_last_string.remove_tail (1)
		end

feature -- Output

	put_delimited_string (string: STRING)
		-- put string with end delimited by ctrl-z code (DEC 26)
		-- Use 'read_string' to read it.
		local
			c_str: ANY
		do
			c_str := string.to_c
			c_put_stream (descriptor, $c_str, string.count)
			bytes_sent := string.count
			write_listener.notify
			put_end_of_string_delimiter
		end

	put_end_of_string_delimiter
			-- put end of string delimiter
		do
			put_raw_character_8 (End_of_string_delimiter)
		end

feature -- Element change

	set_read_listener (a_read_listener: EL_READ_BYTE_COUNTING_LISTENER)
		do
			read_listener := a_read_listener
		end

	set_write_listener (a_write_listener: EL_WRITTEN_BYTE_COUNTING_LISTENER)
		do
			write_listener := a_write_listener
		end

feature {NONE} -- Implementation

	open_read
		do
		end

	open_write
		do
		end

	position: INTEGER
		do
		end

	put_pointer_content (a_pointer: POINTER; a_offset, a_byte_count: INTEGER)
		do
			Precursor (a_pointer, a_offset, a_byte_count)
			bytes_sent := a_byte_count
			write_listener.notify
		end

	read_into_pointer (p: POINTER; start_pos, nb_bytes: INTEGER_32)
		do
			Precursor (p, start_pos, nb_bytes)
			read_listener.notify
		end

feature {NONE} -- Internal attributes

	read_listener: EL_EVENT_LISTENER

	write_listener: EL_EVENT_LISTENER

feature {NONE} -- Constants

	Default_listener: EL_DEFAULT_EVENT_LISTENER
		once ("PROCESS")
			create Result
		end

	Default_packet_size: INTEGER = 512

	End_of_string_delimiter: CHARACTER = '%/26/'
		-- Ctrl-z

	End_of_string_delimiter_code: NATURAL = 26
		-- Ctrl-z

	Packet_buffer: EL_C_STRING_8
			--
		once
			create Result.make (Default_packet_size)
		end

	String_buffer: STRING
			--
		once
			create Result.make (1024)
		end


end