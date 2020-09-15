note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:26:32 GMT (Tuesday 15th September 2020)"
	revision: "10"

class
	DEVELOPMENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [LOCALIZATION_COMMAND_SHELL_TEST_SET]]
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