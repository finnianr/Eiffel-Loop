note
	description: "Application that can be regression tested"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 15:07:52 GMT (Saturday 5th February 2022)"
	revision: "16"

deferred class
	EL_REGRESSION_TESTABLE_APPLICATION

inherit
	EL_LOGGED_APPLICATION
		rename
			log_filter_set as extra_log_filter_set
		redefine
			new_log_manager, new_lio, new_log_filter_set
		end

	EL_MODULE_TEST

feature {NONE} -- Initialization

	initialize
			--
		do
			if not skip_normal_initialize then
				normal_initialize
			end
		end

feature -- Basic operations

	run
			--
		do
			if is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
				test_run
				if not Test.last_test_succeeded then
					exit_code := 1
				end
			else
				normal_run
			end
		end

feature -- Status query

	Is_test_mode: BOOLEAN
			--
		once
			Result := App_option.test
		end

feature {NONE} -- Factory

	new_lio: EL_LOGGABLE
		do
			if logging.is_active then
				Result := Once_log
			else
				create {EL_CRC_32_CONSOLE_ONLY_LOG} Result.make
			end
		end

	new_log_manager: EL_CRC_32_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end

feature {NONE} -- Implementation

	new_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
		do
			Result := Precursor
			Result.show_all ({like Current})
			Result.show_all ({EL_REGRESSION_TESTING_ROUTINES})
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

	test_run
			--
		deferred
		end

end
