note
	description: "[
		Run all sub-applications conforming to ${EL_AUTOTEST_APPLICATION} except for
		those listed in `omitted_apps' tuple.
	]"
	notes: "[
		Rename `omitted_apps' to `none_omitted' if all test apps to be excuted
		
		Option: `-from <type-name>' means start testing from application with type-name.
		But the type-name can also be equal to keyword "start".
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:05:51 GMT (Saturday 29th March 2025)"
	revision: "14"

deferred class
	EL_BATCH_AUTOTEST_APP

inherit
	EL_APPLICATION
		redefine
			options_help
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_NAMING

	EL_SHARED_APPLICATION_LIST

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create omission_list.make_from_tuple (omitted_apps)
		end

feature -- Basic operations

	run
		do
			if attached Application_list as list then
				if attached Args.value (From_option) as type_name and then type_name.count > 0 then
				-- <command> -from X
				-- start testing from application X
					if type_name.same_string ("start") then
						list.start
					else
						list.find_first_equal (type_name.to_latin_1, agent {EL_APPLICATION}.generator)
					end
				else
					list.start
				end
				from until list.after or else execution.return_code.to_boolean loop
					if attached list.item as app and then not omission_list.has (app.generating_type) then
						if attached {EL_AUTOTEST_APPLICATION} app as test_app then
							test (test_app, Void)
						end
					end
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	call_command (arguments_list: EL_ZSTRING_LIST)
		local
			cmd_list: EL_ZSTRING_LIST
		do
			create cmd_list.make (arguments_list.count + 1)
			cmd_list.extend (Executable.name)
			cmd_list.append_sequence (arguments_list)

			lio.put_line (cmd_list.as_word_string)
			lio.put_new_line
			if Args.option_exists ("workbench") then
				cmd_list [1] := W_code_template #$ [execution.item ("ISE_PLATFORM"), Executable.name]
			else
				cmd_list [1] := Executable.path
			end
			execution.system (cmd_list.as_word_string)
		end

	none_omitted: TUPLE
		do
			create Result
		end

	options_help: EL_APPLICATION_HELP_LIST
		do
			Result := Precursor
			Result.extend (From_option, "Start testing from application type name", "")
		end

	test (test_app: EL_AUTOTEST_APPLICATION; extra_arguments: detachable ARRAY [ZSTRING])
		local
			cmd_list: EL_ZSTRING_LIST
		do
			create cmd_list.make_from_general (<< hyphen + test_app.option_name >>)
			if attached extra_arguments as extra then
				cmd_list.append_general (extra)
			end
			call_command (cmd_list)
		end

feature {NONE} -- Deferred

	omitted_apps: TUPLE
		-- class types conforming to `EL_AUTOTEST_APPLICATION' to be skipped.
		-- Rename `omitted_apps as none_omitted' if all test apps are to be executed
		deferred
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

	From_option: STRING = "from"

	W_code_template: ZSTRING
		once
			Result := "build/%S/EIFGENs/classic/W_code/%S"
		end

end