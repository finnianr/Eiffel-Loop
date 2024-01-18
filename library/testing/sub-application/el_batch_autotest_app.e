note
	description: "[
		Run all sub-applications conforming to ${EL_AUTOTEST_APPLICATION} except for
		those listed in `Omissions' tuple.
	]"
	notes: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 7:23:58 GMT (Monday 27th November 2023)"
	revision: "8"

class
	EL_BATCH_AUTOTEST_APP

inherit
	EL_APPLICATION

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_NAMING

	EL_SHARED_APPLICATION_LIST

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

	call_command (arguments_list: EL_ZSTRING_LIST)
		local
			cmd_list: EL_ZSTRING_LIST
		do
			create cmd_list.make (arguments_list.count + 1)
			cmd_list.extend (Executable.name)
			cmd_list.append_sequence (arguments_list)

			lio.put_line (cmd_list.joined_words)
			lio.put_new_line
			if Args.word_option_exists ("workbench") then
				cmd_list [1] := W_code_template #$ [execution.item ("ISE_PLATFORM"), Executable.name]
			else
				cmd_list [1] := Executable.path
			end
			execution.system (cmd_list.joined_words)
		end

	test (application: EL_APPLICATION)
		local
			cmd_list: EL_ZSTRING_LIST
		do
			if attached {EL_AUTOTEST_APPLICATION} application as test_app then
				create cmd_list.make_from_general (<< hyphen.to_string + application.option_name >>)
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

	Omissions: TUPLE
		once
			create Result
		end

	W_code_template: ZSTRING
		once
			Result := "build/%S/EIFGENs/classic/W_code/%S"
		end

end