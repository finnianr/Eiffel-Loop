note
	description: "Extends [$source EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 17:58:16 GMT (Tuesday 18th February 2020)"
	revision: "5"

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
			flush_string_8, set_text_color, set_text_color_light
		end

create
	make

end
