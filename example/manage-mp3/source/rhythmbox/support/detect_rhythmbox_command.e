note
	description: "Summary description for {DETECT_RHYTHMBOX_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 14:19:46 GMT (Thursday 23rd June 2016)"
	revision: "8"

class
	DETECT_RHYTHMBOX_COMMAND

inherit
	EL_OS_COMMAND
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