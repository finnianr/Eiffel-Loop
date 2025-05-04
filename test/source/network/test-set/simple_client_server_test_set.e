note
	description: "Test ${EL_SIMPLE_SERVER} and ${EL_NETWORK_STREAM_SOCKET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:12:49 GMT (Sunday 4th May 2025)"
	revision: "17"

class
	SIMPLE_CLIENT_SERVER_TEST_SET

inherit
	COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_PROTOCOL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["client_server", agent test_client_server]
			>>)
		end

feature -- Tests

	test_client_server
		-- SIMPLE_CLIENT_SERVER_TEST_SET.test_client_server
		local
			server: SIMPLE_SERVER_THREAD
		do
		--	Also used to prove that type references like {SIMPLE_COMMAND_HANDLER}
		--	always return the same object regardless of the thread process that
		--	referenced them.
			create server.make ({SIMPLE_COMMAND_HANDLER})
			server.launch
			Execution_environment.sleep (100)

			lio.put_path_field ("data %S", Text_file_path)
			lio.put_new_line

			do_test ("send_file", 2627758098, agent send_file, [source_file_list.first_path])

			server.wait_to_stop

			assert ("same TYPE [ANY] object", server.same_type_object)
		end


feature {NONE} -- Implementation

	send_file (file_path: FILE_PATH)
		local
			socket: EL_NETWORK_STREAM_SOCKET
		do
			create socket.make_client_by_port (8000, Localhost)
			socket.set_latin_encoding (1)
			lio.put_line ("Connecting")
			socket.connect
			across << "greeting", "number 1", "number 2" >> as cmd loop
				lio.put_labeled_string ("Command", cmd.item)
				lio.put_new_line
				socket.put_line (cmd.item)
				socket.read_line
				lio.put_labeled_string ("Response", socket.last_string (False))
				lio.put_new_line
			end
			socket.put_line (Quit_cmd)
			socket.close
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Text_file_path >>)
		end

feature {NONE} -- Constants

	Quit_cmd: STRING = "quit"

	Text_file_path: FILE_PATH
		once
			Result := Data_dir.txt + "file.txt"
		end

end