note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-04 14:25:46 GMT (Thursday 4th March 2021)"
	revision: "13"

class
	AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [
		CAD_MODEL_TEST_SET,
		LOCALIZATION_COMMAND_SHELL_TEST_SET,
		MONTHLY_STOCK_USE_TEST_SET,
		JOBSERVE_SEARCHER_TEST_SET
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