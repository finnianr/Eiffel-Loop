note
	description: "Encodeable stream with ability to read Ctrl-Z end delimited strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-26 13:16:37 GMT (Friday 26th May 2017)"
	revision: "2"

deferred class
	EL_STREAM_SOCKET

inherit
	STREAM_SOCKET
		rename
			put_string as put_encoded_string_8
		redefine
			read_stream, readstream
		end

	EL_OUTPUT_MEDIUM

	STRING_HANDLER

feature -- Access

	description: STRING
		deferred
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
			last_string.grow (nb_char)
			l_area := last_string.area
			count := c_read_stream (descriptor, nb_char, l_area.base_address)
			if count > 0 then
				last_string.set_count (count)
				bytes_read := count
			else
				bytes_read := 0
				last_string.wipe_out
			end
		end

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
			String_buffer.wipe_out
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

feature -- Output

	put_delimited_string (string: STRING)
			-- put string with end delimited by ctrl-z code (DEC 26)
			-- Use 'read_string' to read it.
		do
			String_buffer.wipe_out
			String_buffer.append (string)
			c_put_stream (descriptor, String_buffer.area.base_address, String_buffer.count)
			put_end_of_string_delimiter
		end

	put_end_of_string_delimiter
			-- put end of string delimiter
		do
			put_character (End_of_string_delimiter)
		end

feature {NONE} -- Unimplemented

	open_read
		do
		end

	open_write
		do
		end

	position: INTEGER
		do
		end

feature {NONE} -- Constants

	Default_packet_size: INTEGER = 512

	End_of_string_delimiter: CHARACTER
			--
		once
			Result := {ASCII}.Ctrl_z.to_character_8
		end

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
