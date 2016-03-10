note
	description: "Summary description for {EL_INTRUSION_SCANNER_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGIN_MONITOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [LOGIN_MONITOR_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE
		do
			create Result
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "login_monitor"

	Description: STRING = "[
		Monitors authorization log for failed login attempts and blacklists them in IP tables
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{LOGIN_MONITOR_APP}, "*"],
				[{LOGIN_MONITOR_COMMAND}, "*"]
			>>
		end
end
