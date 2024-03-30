note
	description: "[
		Sends a desktop notification warning of an error using the VBscript command `msgbox'
		invoked by the Windows `Mshta.exe' command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-29 11:52:09 GMT (Friday 29th March 2024)"
	revision: "1"

class
	EL_NOTIFY_SEND_ERROR_COMMAND

inherit
	EL_NOTIFY_SEND_ERROR_COMMAND_I

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature {NONE} -- Constants

	Template: STRING = "[
		mshta vbscript:Execute("msgbox ""$MESSAGE"",$URGENCY,""$ERROR"":close")
	]"

	Urgency_list: STRING = "vbOKOnly, vbCritical, vbQuestion"
		-- vbOKOnly: Displays OK button only.
		-- vbCritical: Displays Critical Message icon.
		-- vbQuestion: Displays Warning Query icon.

end