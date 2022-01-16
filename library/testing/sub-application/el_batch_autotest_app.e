note
	description: "[
		Run all sub-applications conforming to [$source EL_AUTOTEST_SUB_APPLICATION] except for
		those listed in `Omissions' tuple.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-08 19:24:23 GMT (Saturday 8th January 2022)"
	revision: "2"

class
	EL_BATCH_AUTOTEST_APP

inherit
	EL_SUB_APPLICATION

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
			Execution_environment.set_library_path
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
			if Executable.is_finalized then
				execution.system (Executable.path.to_string.joined (args_tuple))
			else
				lio.put_line (Executable.name.joined (args_tuple))
				lio.put_new_line
			end
		end

	test (application: EL_SUB_APPLICATION)
		local
			cmd_list: EL_ZSTRING_LIST
		do
			if attached {EL_AUTOTEST_SUB_APPLICATION} application as test_app then
				create cmd_list.make_from_general (<< Hypen + application.option_name >>)
				call_command (cmd_list)
			end
		end

feature {NONE} -- Internal attributes

	omission_list: EL_TUPLE_TYPE_LIST [EL_SUB_APPLICATION]

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Run all sub-application tests conforming to " + ({EL_AUTOTEST_SUB_APPLICATION}).name
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