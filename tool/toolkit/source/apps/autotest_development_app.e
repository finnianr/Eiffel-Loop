note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

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
