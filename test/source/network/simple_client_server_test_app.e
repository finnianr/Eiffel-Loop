note
	description: "Test simple client"
	notes: "[
		Option: -simple_client_test
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:29:55 GMT (Tuesday 10th November 2020)"
	revision: "15"

class
	SIMPLE_CLIENT_SERVER_TEST_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			visible_types
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			log.enter ("run")
			Test.do_file_test ("txt/file.txt", agent send_file, 2486921902)
			log.exit
		end

feature {NONE} -- Tests

	send_file (file_path: EL_FILE_PATH)
		local
			server: SIMPLE_SERVER_THREAD
			socket: EL_NETWORK_STREAM_SOCKET
		do
			log.enter ("send_file")
			create server.make
			server.launch
			Execution_environment.sleep (100)

			create socket.make_client_by_port (8000, "localhost")
			socket.set_latin_encoding (1)
			log.put_line ("Connecting")
			socket.connect
			across << "greeting", "number 1", "number 2" >> as cmd loop
				log.put_labeled_string ("Command", cmd.item)
				log.put_new_line
				socket.put_line (cmd.item)
				socket.read_line
				log.put_labeled_string ("Response", socket.last_string (False))
				log.put_new_line
			end
			socket.put_line (Quit_cmd)
			socket.close

			server.wait_to_stop
			log.exit
		end

feature {NONE} -- Implementation

	extra_log_filter_set: EL_LOG_FILTER_SET [SIMPLE_SERVER_THREAD]
			--
		do
			create Result.make
		end

	visible_types: TUPLE [SIMPLE_COMMAND_HANDLER]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Test for class EL_SIMPLE_SERVER"

	Quit_cmd: STRING = "quit"

end