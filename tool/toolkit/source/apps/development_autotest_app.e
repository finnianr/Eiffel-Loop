note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 12:40:43 GMT (Monday 18th January 2021)"
	revision: "11"

class
	DEVELOPMENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [LOCALIZATION_COMMAND_SHELL_TEST_SET]
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

end