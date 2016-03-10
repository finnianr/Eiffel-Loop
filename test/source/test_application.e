note
	description: "Summary description for {TEST_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:25:06 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	TEST_APPLICATION

inherit
	EL_SUB_APPLICATION

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_TEST

feature -- Basic operations

	initialize
			--
		do
			if Execution.current_working_directory /~ Test_data_directory then
				Execution.change_working_path (Test_data_directory.to_path)
			end
		end

feature {NONE} -- Constants

	Test_data_directory: EL_DIR_PATH
			--
		once
			create Result.make_from_unicode (Execution.item ("EIFFEL_LOOP"))
			Result.append_dir_path ("projects.data")
		end

end
