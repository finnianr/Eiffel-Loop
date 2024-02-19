note
	description: "Bext client test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-16 10:06:13 GMT (Friday 16th February 2024)"
	revision: "15"

class
	BEXT_CLIENT_TEST_APP

inherit
	EL_LOGGED_APPLICATION
		redefine
			Ask_user_to_quit
		end

	EL_PROTOCOL_CONSTANTS

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create net_socket.make_client_by_port (8001, Localhost)
			create parse_event_generator.make
			create signal_math.make
		end

feature -- Basic operations

	run
			--
		local
			wave_form: COLUMN_VECTOR_COMPLEX_64; i: INTEGER
		do
			log.enter ("run")
			net_socket.connect

			from i := 1 until i > 2 loop
				wave_form := signal_math.cosine_waveform (4, 7, 0.5)
				parse_event_generator.send_object (wave_form, net_socket)
				i := i + 1
			end

			net_socket.close
			log.exit
		end

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	input_file_path: FILE_NAME

	net_socket: EL_NETWORK_STREAM_SOCKET

	parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR

	signal_math: SIGNAL_MATH

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = true

	Description: STRING = "Test client for BEXT (Binary Encoded XML Transfer)"

end