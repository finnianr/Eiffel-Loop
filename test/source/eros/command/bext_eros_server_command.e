note
	description: "Bext eros server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	BEXT_EROS_SERVER_COMMAND

inherit
	EROS_SERVER_COMMAND [FFT_COMPLEX_64, SIGNAL_MATH]
		redefine
			serve
		end

create
	make

feature -- Constants

	Description: STRING = "Test server for BEXT (Binary Encoded XML Transfer) (Ctrl-c to shutdown)"

feature -- Basic operations

	serve (client_socket: EL_NETWORK_STREAM_SOCKET)
			--
		local
			wave_form: COLUMN_VECTOR_COMPLEX_64 i: INTEGER
		do
			log.enter ("serve")
			from i := 1 until i > 2 loop
				create wave_form.make_from_binary_stream (client_socket)
				wave_form.set_output_path ("vector." + i.out + ".xml")
				wave_form.store
				i := i + 1
			end
			client_socket.close
			log.exit
		end
end