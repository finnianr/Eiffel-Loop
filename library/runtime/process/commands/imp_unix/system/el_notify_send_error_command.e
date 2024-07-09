note
	description: "[
		Sends a desktop notification warning of an error using the `notify-send' command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:23:48 GMT (Tuesday 9th July 2024)"
	revision: "3"

class
	EL_NOTIFY_SEND_ERROR_COMMAND

inherit
	EL_NOTIFY_SEND_ERROR_COMMAND_I

	EL_UNIX_IMPLEMENTATION

create
	make

feature {NONE} -- Constants

	Urgency_list: STRING = "low, normal, critical"

	Default_template: STRING = "[
		notify-send --urgency $URGENCY --icon=error "$ERROR" "$MESSAGE"
	]"

end