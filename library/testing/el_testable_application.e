note
	description: "Summary description for {EL_TESTABLE_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:59 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_TESTABLE_APPLICATION

inherit
	EL_MODULE_ARGS

	EL_MODULE_TEST

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Status query

	is_test_mode: BOOLEAN
			--
		once
			Result := Args.word_option_argument (latin_option_name).is_equal ("test")
		end

feature -- Basic operations

	initialize
			--
		do
			if not is_test_mode then
				normal_initialize
			end
		end

	run
			--
		do
			if is_test_mode then
				if Execution.current_working_directory /~ Test_data_directory then
					Execution.change_working_path (Test_data_directory.to_path)
				end
				test_run
			else
				normal_run
			end
		end

feature {NONE} -- Implementation

	latin_option_name: EL_ASTRING
			--
		deferred
		end

	normal_initialize
			--
		deferred
		end

	test_initialize
			--
		do
		end

	normal_run
			--
		deferred
		end

	test_run
			--
		deferred
		end

feature {NONE} -- Constants

	Test_data_directory: EL_DIR_PATH
			--
		once
			Result := Execution.variable_dir_path ("EIFFEL_LOOP")
			Result.append_dir_path ("projects.data")
		end

end
