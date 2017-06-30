note
	description: "Summary description for {DETECT_RHYTHMBOX_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-18 10:43:18 GMT (Sunday 18th June 2017)"
	revision: "2"

class
	DETECT_RHYTHMBOX_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_with_name ("detect_rhythmbox", "ps -C rhythmbox")
		end

feature -- Status query

	is_launched: BOOLEAN
		do
			Result := not has_error
		end

end
