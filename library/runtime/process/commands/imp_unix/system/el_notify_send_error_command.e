note
	description: "[
		Sends a desktop notification warning of an error using the `notify-send' command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-29 11:41:52 GMT (Friday 29th March 2024)"
	revision: "2"

class
	EL_NOTIFY_SEND_ERROR_COMMAND

inherit
	EL_NOTIFY_SEND_ERROR_COMMAND_I
	
	EL_UNIX_IMPLEMENTATION

create
	make

feature {NONE} -- Constants

	Urgency_list: STRING = "low, normal, critical"

	template: STRING = "[
		notify-send --urgency $URGENCY --icon=error "$ERROR" "$MESSAGE"
	]"

end