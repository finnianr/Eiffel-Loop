note
	description: "Socket that can help debug network protocols"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 12:40:21 GMT (Friday 2nd March 2018)"
	revision: "1"

class
	FCGI_DEBUGGING_STREAM_SOCKET

inherit
	EL_NETWORK_STREAM_SOCKET
		redefine
			make_empty, close_socket, read_to_managed_pointer, put_managed_pointer, put_pointer_content
		end

create
	make_server_by_port, make_empty

feature {NONE} -- Implementation

	make_empty
		do
			Precursor
			create file_read.make_open_write ("/tmp/" + generator + ".read")
			create file_write.make_open_write ("/tmp/" + generator + ".write")
		end

	close_socket
		do
			Precursor
			file_read.close; file_write.close
		end

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
		do
			file_write.put_managed_pointer (p, start_pos, nb_bytes)
			file_write.flush
			Precursor (p, start_pos, nb_bytes)
		end

	put_pointer_content (a_pointer: POINTER; offset, a_byte_count: INTEGER)
		local
			bytes_sent, return_val: INTEGER
		do
			from until a_byte_count = bytes_sent loop
				return_val := c_write (descriptor, a_pointer + offset + bytes_sent, a_byte_count - bytes_sent)
				if return_val > 0 then
					bytes_sent := bytes_sent + return_val
				end
			end
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
		do
			Precursor (p, start_pos, nb_bytes)
			file_read.put_managed_pointer (p, start_pos, nb_bytes)
		end

feature {NONE} -- Internal attributes

	file_read: RAW_FILE

	file_write: RAW_FILE
end
