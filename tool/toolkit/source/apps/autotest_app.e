note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-07 16:59:10 GMT (Friday 7th January 2022)"
	revision: "14"

class
	AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [
		CAD_MODEL_TEST_SET,
		FILE_MANIFEST_TEST_SET,
		LOCALIZATION_COMMAND_SHELL_TEST_SET,
		MONTHLY_STOCK_USE_TEST_SET
	]
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