note
	description: "Summary description for {DETECT_RHYTHMBOX_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-19 11:01:58 GMT (Monday 19th January 2015)"
	revision: "7"

class
	DETECT_RHYTHMBOX_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			make as make_general_command
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_general_command ("ps -C rhythmbox")
		end

feature -- Status query

	is_launched: BOOLEAN
		do
			Result := not has_error
		end

feature {NONE} -- Implementation

	reset
		do
		end
end
