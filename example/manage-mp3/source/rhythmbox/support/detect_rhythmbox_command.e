note
	description: "Detect rhythmbox command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

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
