note
	description: "[
		Sends a desktop notification warning of an error using the `notify-send' command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-21 9:18:45 GMT (Thursday 21st March 2024)"
	revision: "1"

class
	EL_NOTIFY_SEND_ERROR_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [urgency, error, message: STRING]]
		export
			{ANY} put_string
		end

create
	make

feature -- Constants

	Urgency: TUPLE [low, normal, critical: IMMUTABLE_STRING_8]
		-- urgency=LEVEL Specifies the urgency level (low, normal, critical).
		once
			create Result
			Tuple.fill_immutable (Result, "low, normal, critical")
		end

feature {NONE} -- Constants

	template: STRING = "[
		notify-send --urgency $URGENCY --icon=error "$ERROR" "$MESSAGE"
	]"

end