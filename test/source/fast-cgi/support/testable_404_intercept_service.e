note
	description: "Test version of ${EL_404_INTERCEPT_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-25 15:21:02 GMT (Tuesday 25th February 2025)"
	revision: "4"

class
	TESTABLE_404_INTERCEPT_SERVICE

inherit
	EL_404_INTERCEPT_SERVICE
		redefine
			make, new_servlet, new_authorization_log, new_sendmail_log
		end

	SHARED_DEV_ENVIRON

create
	make, make_port

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		do
			Precursor (config_path)
			across monitored_logs as list loop
				if attached (Log_dir + Directory.new (list.item.log_path).base) as log_path then
					list.item.log_path.share (log_path.to_string)
				end
			end
		ensure then
			test_log_exists: across monitored_logs as list all Directory.new (list.item.log_path).exists end
		end

feature {NONE} -- Implementation

	new_authorization_log: TEST_AUTH_LOG_ENTRIES
		do
			create Result.make (config.log_tail_count)
		end

	new_sendmail_log: TEST_MAIL_LOG_ENTRIES
		do
			create Result.make (config.log_tail_count)
		end

	new_servlet: TESTABLE_404_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

feature {NONE} -- Constants

	Log_dir: EL_DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "test/data/network"
		end

end