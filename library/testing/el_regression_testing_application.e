note
	description: "Application that can be regression tested"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-09 8:45:13 GMT (Saturday 9th July 2016)"
	revision: "7"

deferred class
	EL_REGRESSION_TESTING_APPLICATION

inherit
	EL_MODULE_ARGS

	EL_MODULE_TEST

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

	EL_TEST_CONSTANTS

feature {NONE} -- Initialization

	initialize
			--
		do
			if is_test_mode and then Directory.current_working /~ test_data_dir then
				Execution.change_working_path (test_data_dir.to_path)
			end
			if not skip_normal_initialize then
				normal_initialize
			end
		end

feature -- Basic operations

	run
			--
		do
			if is_test_mode then
				test_run
			else
				normal_run
			end
		end

feature -- Status query

	is_test_mode: BOOLEAN
			--
		once
			Result := Args.value (new_option_name).is_equal ("test")
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

	normal_run
			--
		deferred
		end

	skip_normal_initialize: BOOLEAN
		do
			Result := is_test_mode
		end

	test_initialize
			--
		do
		end

	test_run
			--
		deferred
		end

end
