note
	description: "Test [$source EL_SIMPLE_SERVER] and [$source EL_NETWORK_STREAM_SOCKET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 10:23:10 GMT (Monday 15th March 2021)"
	revision: "1"

class
	SIMPLE_CLIENT_SERVER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_LOG

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("client_server", agent test_client_server)
		end

feature -- Tests

	test_client_server
		local
			server: SIMPLE_SERVER_THREAD
		do
			create server.make
			server.launch
			Execution_environment.sleep (100)

			do_test ("send_file", 2627758098, agent send_file, [source_file_list.first_path])

			server.wait_to_stop
		end


feature {NONE} -- Implementation

	send_file (file_path: EL_FILE_PATH)
		local
			socket: EL_NETWORK_STREAM_SOCKET
		do
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
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< EL_test_data_dir + "txt/file.txt" >>)
		end

feature {NONE} -- Constants

	Quit_cmd: STRING = "quit"

end