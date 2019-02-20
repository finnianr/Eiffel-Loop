note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 13:39:34 GMT (Wednesday 20th February 2019)"
	revision: "6"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			Visible_types
		end

create
	make

feature {NONE} -- Constants

	Evaluator_types: TUPLE [LOCALIZATION_COMMAND_SHELL_TEST_EVALUATOR]
		once
			create Result
		end

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
