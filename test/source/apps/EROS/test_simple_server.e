note
	description: "Summary description for {TEST_SIMPLE_SERVER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 11:23:29 GMT (Friday 8th July 2016)"
	revision: "1"

class
	TEST_SIMPLE_SERVER

inherit
	REGRESSION_TESTING_SUB_APPLICATION
		redefine
			option_name, initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create server.make_local (8000)
		end

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_test ("empty.txt", agent test_server, 235123026)
		end

feature -- Test

	test_server (file_path: EL_FILE_PATH)
		do
			log.enter ("test_server")
			server.do_service_loop
			log.exit
		end

feature {NONE} -- Implementation

	server: EL_SIMPLE_SERVER [SIMPLE_COMMAND_HANDLER]

feature {NONE} -- Constants

	Option_name: STRING = "simple_server"

	Description: STRING = "Test class EL_SIMPLE_SERVER"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{TEST_SIMPLE_SERVER}, All_routines],
				[{SIMPLE_COMMAND_HANDLER}, All_routines],
				[{EL_SIMPLE_SERVER [SIMPLE_COMMAND_HANDLER]}, All_routines]
			>>
		end

end
