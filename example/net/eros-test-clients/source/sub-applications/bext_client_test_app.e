note
	description: "Bext client test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	BEXT_CLIENT_TEST_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Ask_user_to_quit, option_name
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create net_socket.make_client_by_port (8001, "localhost")
			create parse_event_generator.make_with_output (net_socket)
			create signal_math.make
		end

feature -- Basic operations

	run
			--
		local
			wave_form: COLUMN_VECTOR_COMPLEX_DOUBLE
			i: INTEGER
		do
			log.enter ("run")
			net_socket.connect

			from i := 1 until i > 2 loop
				wave_form := signal_math.cosine_waveform (4, 7, 0.5)
				parse_event_generator.send_object (wave_form)
				i := i + 1
			end

			net_socket.close
			log.exit
		end

feature {NONE} -- Implementation

	net_socket: EL_NETWORK_STREAM_SOCKET

	parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR

	signal_math: SIGNAL_MATH

	input_file_path: FILE_NAME

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = true

	Option_name: STRING = "bext_test_client"

	Description: STRING = "Test client for BEXT (Binary Encoded XML Transfer)"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{BEXT_CLIENT_TEST_APP}, All_routines]
			>>
		end

end
