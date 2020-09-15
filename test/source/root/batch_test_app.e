note
	description: "[
		Run all sub-application tests conforming to [$source EL_AUTOTEST_SUB_APPLICATION]
		and [$source TEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:59:39 GMT (Tuesday 15th September 2020)"
	revision: "3"

class
	BATCH_TEST_APP

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
			--
		local

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
			if Executable.is_finalized then
				execution.system (Executable.path.to_string.joined (args_tuple))
			else
				lio.put_line (Executable.name.joined (args_tuple))
				lio.put_new_line
			end
		end

	test (application: EL_SUB_APPLICATION)
		local
			ecf_name: ZSTRING; cmd_list: EL_ZSTRING_LIST
		do
			if attached {TEST_SUB_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 1) + Dot_ecf

			elseif attached {EL_AUTOTEST_SUB_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 2) + Dot_ecf

			else
				ecf_name := Dot_ecf
			end
			if ecf_name /= Dot_ecf then
				ecf_name.to_lower
				lio.put_labeled_string ("Library", ecf_name)
				lio.put_new_line
				create cmd_list.make_from_general (<< Hypen + application.option_name >>)
				call_command (cmd_list)
				if application.generating_type ~ {BASE_AUTOTEST_APP} and then execution.return_code = 0 then
					cmd_list.append_general (<< "-test_set", "ZSTRING_TEST_SET", "-zstring_codec", "ISO-8859-1" >>)
					call_command (cmd_list)
				end
			end
		end

feature {NONE} -- Internal attributes

	omission_list: EL_TUPLE_TYPE_LIST [EL_SUB_APPLICATION]

feature {NONE} -- Constants

	Description: STRING = "[
		Run all sub-application tests conforming to EL_AUTOTEST_SUB_APPLICATION and TEST_SUB_APPLICATION
	]"

	Dot_ecf: ZSTRING
		once
			Result := ".ecf"
		end

	Hypen: ZSTRING
		once
			Result := "-"
		end

	Omissions: TUPLE [FTP_TEST_APP, FTP_AUTOTEST_APP]
		once
			create Result
		end

end