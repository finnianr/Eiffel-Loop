note
	description: "Console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	EL_CONSOLE

inherit
	CONSOLE
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8,
			make as obsolete_make
		end

	EL_CONSOLE_ENCODEABLE

create
	make

feature {NONE} -- Initialization

	make (console: PLAIN_TEXT_FILE)
		require
			is_console: attached {CONSOLE} console
		do
			set_path (console.path)
			file_pointer := console.file_pointer
			mode := console.mode
		end

feature -- Basic operations

	put_string_general (str: READABLE_STRING_GENERAL)
		do
		end

end
