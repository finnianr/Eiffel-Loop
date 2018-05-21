note
	description: "Test simple client"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	TEST_SIMPLE_CLIENT

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end


create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create socket.make_client_by_port (8000, "localhost")
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			log.put_line ("Connecting")
			socket.connect
			across << "greeting hello", "one 1", "two 2", "quit" >> as word loop
				log.put_line (word.item)
				socket.put_string_8 (word.item)
				socket.put_new_line
			end
			socket.close
			log.exit
		end

feature {NONE} -- Implementation

	socket: EL_NETWORK_STREAM_SOCKET

feature {NONE} -- Constants

	Option_name: STRING = "simple_client"

	Description: STRING = "Test for class EL_SIMPLE_SERVER"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_SIMPLE_CLIENT}, All_routines]
			>>
		end

end
