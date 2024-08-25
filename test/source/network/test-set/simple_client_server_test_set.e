note
	description: "Test ${EL_SIMPLE_SERVER} and ${EL_NETWORK_STREAM_SOCKET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 6:42:20 GMT (Sunday 25th August 2024)"
	revision: "15"

class
	SIMPLE_CLIENT_SERVER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT

	SHARED_DEV_ENVIRON

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
			create server.make
			server.launch
			Execution_environment.sleep (100)

			lio.put_path_field ("data %S", Text_file_path)
			lio.put_new_line

			do_test ("send_file", 2627758098, agent send_file, [source_file_list.first_path])

			server.wait_to_stop
		end


feature {NONE} -- Implementation

	eiffel_loop_dir: DIR_PATH
		do
			Result := Dev_environ.Eiffel_loop_dir
		end

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
			Result := Dev_environ.EL_test_data_dir + "txt/file.txt"
		end

end