note
	description: "Summary description for {EL_INTRUSION_SCANNER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-22 17:20:36 GMT (Friday 22nd May 2015)"
	revision: "5"

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
