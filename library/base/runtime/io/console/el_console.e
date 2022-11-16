note
	description: "Console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_CONSOLE

inherit
	CONSOLE
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8,
			make as obsolete_make
		end

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