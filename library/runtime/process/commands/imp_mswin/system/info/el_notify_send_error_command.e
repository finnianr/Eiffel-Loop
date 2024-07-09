note
	description: "[
		Sends a desktop notification warning of an error using the VBscript command `msgbox'
		invoked by the Windows `Mshta.exe' command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:51:05 GMT (Tuesday 9th July 2024)"
	revision: "2"

class
	EL_NOTIFY_SEND_ERROR_COMMAND

inherit
	EL_NOTIFY_SEND_ERROR_COMMAND_I

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature {NONE} -- Constants

	Default_template: STRING = "[
		mshta vbscript:Execute("msgbox ""$MESSAGE"",$URGENCY,""$ERROR"":close")
	]"

	Urgency_list: STRING = "vbOKOnly, vbCritical, vbQuestion"
		-- vbOKOnly: Displays OK button only.
		-- vbCritical: Displays Critical Message icon.
		-- vbQuestion: Displays Warning Query icon.

end