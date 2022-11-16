note
	description: "File and highlighted console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_CONSOLE_LOG_OUTPUT
		undefine
			clear, flush_string_8, move_cursor_up, set_text_color, set_text_color_light
		end

	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		rename
			make as make_output
		undefine
			flush, write_console, write_escape_sequence
		end

create
	make

end