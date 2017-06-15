note
	description: "Summary description for {EL_MODULE_TEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-19 9:05:22 GMT (Thursday 19th January 2017)"
	revision: "2"

deferred class
	EL_MODULE_TEST

inherit
	EL_MODULE

	EL_MODULE_LOG
		redefine
			new_lio
		end

	EL_MODULE_LOG_MANAGER
		redefine
			new_log_manager
		end

feature -- Access

	Test: EL_REGRESSION_TESTING_ROUTINES
			--
		once
			create Result.make (work_area_dir)
		end

feature {NONE} -- Factory

	new_lio: EL_LOGGABLE
		do
			if logging.is_active then
				Result := Once_log
			else
				create {EL_TESTING_CONSOLE_ONLY_LOG} Result.make (Test.Crc_32)
			end
		end

	new_log_manager: EL_LOG_MANAGER
		do
			create {EL_TESTING_LOG_MANAGER} Result.make (Test.Crc_32)
		end

feature {NONE} -- Implementation

	work_area_dir: EL_DIR_PATH
		deferred
		end

end
