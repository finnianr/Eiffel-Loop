note
	description: "Summary description for {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-31 14:27:24 GMT (Tuesday 31st October 2017)"
	revision: "4"

class
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_CONSOLE_LOG_OUTPUT
		undefine
			set_text_blue, set_text_brown, set_text_dark_gray, set_text_default, set_text_light_blue,
			set_text_light_cyan, set_text_light_green, set_text_purple, set_text_red,
			flush_string_8
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
