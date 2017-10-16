note
	description: "Summary description for {EIFFEL_CODE_HIGHLIGHTING_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-11 13:08:22 GMT (Wednesday 11th October 2017)"
	revision: "4"

class
	CODE_HIGHLIGHTING_TEST_APP

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
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
			Test.do_all_files_test ("latin1-sources/kernel", "*.e", agent test_code_highlighting, 2427639648)
	 	end

	normal_run
		do
		end

feature -- Tests

	test_code_highlighting (file_path: EL_FILE_PATH)
			--
		local
			transformer: CODE_HIGHLIGHTING_TRANSFORMER
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CODE_HIGHLIGHTING_TEST_APP}, All_routines]
			>>
		end

end
