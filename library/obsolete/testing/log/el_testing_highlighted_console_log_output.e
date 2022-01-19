note
	description: "Extends [$source EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 12:27:09 GMT (Tuesday 18th January 2022)"
	revision: "8"

class
	EL_TESTING_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

obsolete
	"Use EL_CRC_32_HIGHLIGHTED_CONSOLE_LOG_OUTPU"

inherit
	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		undefine
			write_console
		end

	EL_TESTING_CONSOLE_LOG_OUTPUT
		undefine
			clear, flush_string_8, move_cursor_up, set_text_color, set_text_color_light
		end

create
	make

end