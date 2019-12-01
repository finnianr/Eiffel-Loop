note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-01 12:05:06 GMT (Sunday 1st December 2019)"
	revision: "7"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			Visible_types
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines]
			>>
		end

	visible_types: TUPLE [EL_FTP_PROTOCOL]
		do
			create Result
		end

	evaluator_types: TUPLE [LOCALIZATION_COMMAND_SHELL_TEST_EVALUATOR]
		do
			create Result
		end

end
