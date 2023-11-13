note
	description: "[
		Run all sub-applications conforming to [$source EL_AUTOTEST_APPLICATION] except for
		those listed in `Omissions' tuple.
	]"
	notes: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 10:26:08 GMT (Monday 13th November 2023)"
	revision: "6"

class
	EL_BATCH_AUTOTEST_APP

inherit
	EL_APPLICATION

	EL_SHARED_APPLICATION_LIST

	EL_MODULE_NAMING

	EL_MODULE_EXECUTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create omission_list.make_from_tuple (Omissions)
		end

feature -- Basic operations

	run
		do
			across Application_list as app until execution.return_code.to_boolean loop
				if not Omission_list.has (app.item.generating_type) then
					test (app.item)
				end
			end
		end

feature {NONE} -- Implementation

	call_command (cmd_list: EL_ZSTRING_LIST)
		local
			args_tuple: TUPLE
		do
			args_tuple := [' ', cmd_list.joined_words]
			lio.put_line (Executable.name.joined (args_tuple))
			lio.put_new_line
			execution.system (Executable.path.to_string.joined (args_tuple))
		end

	test (application: EL_APPLICATION)
		local
			cmd_list: EL_ZSTRING_LIST
		do
			if attached {EL_AUTOTEST_APPLICATION} application as test_app then
				create cmd_list.make_from_general (<< Hypen + application.option_name >>)
				call_command (cmd_list)
			end
		end

feature {NONE} -- Internal attributes

	omission_list: EL_TUPLE_TYPE_LIST [EL_APPLICATION]

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Run all sub-application tests conforming to " + ({EL_AUTOTEST_APPLICATION}).name
		end

	Dot_ecf: ZSTRING
		once
			Result := ".ecf"
		end

	Hypen: ZSTRING
		once
			Result := "-"
		end

	Omissions: TUPLE
		once
			create Result
		end

end