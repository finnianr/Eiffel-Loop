note
	description: "[
		Abstraction for command that takes a file input and outputs a file when `execute' is called
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "3"

deferred class
	EL_FILE_INPUT_OUTPUT_COMMAND_I

inherit
	EL_COMMAND

feature -- Element change

	set_input_output_path (a_input_path, a_output_path: FILE_PATH)
		deferred
		end
end