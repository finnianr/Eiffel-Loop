note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 14:25:13 GMT (Friday 14th February 2020)"
	revision: "9"

class
	DEVELOPMENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION
		redefine
			Visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_FTP_PROTOCOL]
		do
			create Result
		end

	test_type, test_types_all: TUPLE [LOCALIZATION_COMMAND_SHELL_TEST_SET]
		do
			create Result
		end

end
