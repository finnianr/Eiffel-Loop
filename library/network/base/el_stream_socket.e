note
	description: "Summary description for {EL_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_STREAM_SOCKET

inherit
	IO_MEDIUM
		rename
			handle as descriptor,
			handle_available as descriptor_available
		end

feature -- Input

	read_string
			-- read string with end delimited by ctrl-z code (DEC 26)
		require else
			socket_exists: exists;
			opened_for_read: is_open_read
		local
			transmission_complete: BOOLEAN
			delimiter_code: NATURAL
			packet: like Packet_buffer
			count: INTEGER
		do
			delimiter_code := End_of_string_delimiter.natural_32_code
			packet := Packet_buffer
			packet.set_count (Default_packet_size)
			String_buffer.clear_all
			from until transmission_complete loop
				count := c_read_stream (descriptor, packet.capacity, packet.base_address)
				if count > 0 then
					packet.set_count (count)
					packet.fill_string (String_buffer)
					transmission_complete := packet.item (count) = delimiter_code
				else
					transmission_complete := true
				end
			end
			bytes_read := String_buffer.count
			String_buffer.remove_tail (1)
			last_string := String_buffer.string
		end

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' characters.
			-- Make result available in `last_string'.
		require else
			socket_exists: exists;
			opened_for_read: is_open_read
		local
			packet: like Packet_buffer
			count: INTEGER
		do
			create packet.make (nb_char)
			String_buffer.clear_all
			count := c_read_stream (descriptor, packet.capacity, packet.base_address)
			if count > 0 then
				packet.set_count (count)
				packet.fill_string (String_buffer)
			end
			bytes_read := count
			last_string := String_buffer.string
		end

feature -- Output

	put_delimited_string (string: STRING)
			-- put string with end delimited by ctrl-z code (DEC 26)
			-- Use 'read_string' to read it.
		do
			String_buffer.clear_all
			String_buffer.append (string)
			c_put_stream (descriptor, String_buffer.area.base_address, String_buffer.count)
			put_end_of_string_delimiter
		end

	put_end_of_string_delimiter
			-- put end of string delimiter
		do
			put_character (End_of_string_delimiter)
		end

feature {NONE} -- Implementation

	c_put_stream (fd: INTEGER; s: POINTER; length: INTEGER)
			-- External routine to write stream pointed by `s' of
			-- length `length' to socket `fd'
		deferred
		end

	c_read_stream (fd: INTEGER; l: INTEGER; buf: POINTER): INTEGER
			-- External routine to read a `l' number of characters
			-- into packet `buf' from socket `fd'
		deferred
		end

feature {NONE} -- Constants

	String_buffer: STRING
			--
		once
			create Result.make (1024)
		end

	Packet_buffer: EL_C_STRING_8
			--
		once
			create Result.make (Default_packet_size)
		end

	End_of_string_delimiter: CHARACTER
			--
		once
			Result := {ASCII}.Ctrl_z.to_character_8
		end

	Default_packet_size: INTEGER = 512

end
