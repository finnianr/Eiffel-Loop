note
	description: "Summary description for {EL_COUNTING_NETWORK_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET

inherit
	EL_NETWORK_STREAM_SOCKET
		redefine
			read_string, read_stream, read_natural_16,
			put_string, put_delimited_string, put_character, put_natural_16
		end

create
	make_client_by_port, make_server_by_port

feature -- Access

	bytes_received: INTEGER_64

	bytes_sent: INTEGER_64

feature -- Element change

	reset_counts
			--
		do
			bytes_received := 0
			bytes_sent := 0
		end

feature -- Input

	read_string
			--
		do
			Precursor
			bytes_received := bytes_received + last_string.count + 1
		end

	read_stream (nb_char: INTEGER)
			--
		do
			Precursor (nb_char)
			bytes_received := bytes_received + last_string.count
		end

	read_natural_16
			--
		do
			Precursor
			bytes_received := bytes_received + 2
		end

feature -- Output

	put_delimited_string (string: STRING)
			-- put string with end delimited by ctrl-z code (DEC 26)
			-- Use 'read_string' to read it.
		do
			Precursor (string)
			bytes_sent := bytes_sent + string.count
		end

	put_character (c: CHARACTER)
			-- Write `c' to medium.
		do
			Precursor (c)
			bytes_sent := bytes_sent + 1
		end

	put_natural_16 (i: NATURAL_16)
			-- Write `i' to medium.
		do
			Precursor (i)
			bytes_sent := bytes_sent + 2
		end

	put_string (string: STRING)
			-- Write string `s' to socket.
		do
			Precursor (string)
			bytes_sent := bytes_sent + string.count
		end

end
