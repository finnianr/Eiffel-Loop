note
	description: "Extends `EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-18 17:37:52 GMT (Friday 18th August 2017)"
	revision: "2"

class
	EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		rename
			make as make_file_and_console
		export
			{ANY} extendible
		undefine
			put_file_string
		end

	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT
		undefine
			set_text_blue, set_text_brown, set_text_dark_gray, set_text_default, set_text_light_blue,
			set_text_light_cyan, set_text_light_green, set_text_purple, set_text_red,
			flush_string_8
		end

create
	make

end
