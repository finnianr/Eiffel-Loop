note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 12:14:51 GMT (Thursday 14th February 2019)"
	revision: "4"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			visible_types
		end

create
	make

feature -- Basic operations

	initialize
		do
		end

	run
		do
			apply (agent localization_command_shell_test_set.test_add_unchecked)
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

	Visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			Result := << {EL_FTP_PROTOCOL} >>
		end

end
