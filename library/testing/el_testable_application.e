note
	description: "Summary description for {EL_TESTABLE_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:47:53 GMT (Wednesday 16th December 2015)"
	revision: "7"

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
			Result := Args.value (new_option_name).is_equal ("test")
		end

feature -- Basic operations

	initialize
			--
		do
			if is_test_mode and then Directory.current_working /~ Test_data_directory then
				Execution.change_working_path (Test_data_directory.to_path)
			end
			if not skip_normal_normal_initialize then
				normal_initialize
			end
		end

	run
			--
		do
			if is_test_mode then
				test_run
			else
				normal_run
			end
		end

feature {NONE} -- Implementation

	new_option_name: ZSTRING
			--
		deferred
		end

	normal_initialize
			--
		deferred
		end

	skip_normal_normal_initialize: BOOLEAN
		do
			Result := is_test_mode
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
