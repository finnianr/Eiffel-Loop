note
	description: "Extends [$source EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:04:34 GMT (Friday 31st January 2020)"
	revision: "4"

class
	EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
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
