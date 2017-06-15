note
	description: "Summary description for {EIFFEL_CODE_HIGHLIGHTING_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 7:53:47 GMT (Thursday 4th August 2016)"
	revision: "2"

class
	EIFFEL_CODE_HIGHLIGHTING_TEST_APP

inherit
	REGRESSION_TESTING_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	normal_initialize
			--
		do
		end

	test_run
			--
	 	do
			Test.do_all_files_test ("sample-source/kernel", "*.e", agent test_code_highlighting, 2427639648)
	 	end

	 normal_run
	 	do
	 	end

feature -- Tests

	test_code_highlighting (file_path: EL_FILE_PATH)
			--
		local
			transformer: EIFFEL_CODE_HIGHLIGHTING_TRANSFORMER
			output_path: EL_FILE_PATH; html_file: EL_PLAIN_TEXT_FILE
		do
			log.enter ("test_code_highlighting")
			output_path := file_path.without_extension
			output_path.add_extension ("e.html")
			create html_file.make_open_write (output_path)
			create transformer.make (html_file)
			transformer.set_file_path (file_path)
			transformer.edit
			html_file.close
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "test_eiffel_code_highlighting"

	Description: STRING = "Test highlighting Eiffel keywords, comments and class names."

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_CODE_HIGHLIGHTING_TEST_APP}, All_routines]
			>>
		end

end
