note
	description: "Summary description for {AUTOTEST_DEVELOPMENT_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Console.show_all (<< {EL_FTP_PROTOCOL} >>)
		end

feature -- Basic operations

	run
		do
			do_file_data_test (agent localization_command_shell_test_set.test_add_unchecked)
		end

feature -- Tests

	localization_command_shell_test_set: LOCALIZATION_COMMAND_SHELL_TEST_SET
		do
			create Result
		end

feature {NONE} -- Constants

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines]
			>>
		end

end
