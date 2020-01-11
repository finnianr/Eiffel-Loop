note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 10:42:52 GMT (Saturday 11th January 2020)"
	revision: "8"

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

	visible_types: TUPLE [EL_FTP_PROTOCOL]
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE [LOCALIZATION_COMMAND_SHELL_TEST_EVALUATOR]
		do
			create Result
		end

end
