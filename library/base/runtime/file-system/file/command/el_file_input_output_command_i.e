note
	description: "[
		Abstraction for command that takes a file input and outputs a file when `execute' is called
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:45:56 GMT (Thursday 9th September 2021)"
	revision: "2"

deferred class
	EL_FILE_INPUT_OUTPUT_COMMAND_I

inherit
	EL_COMMAND

feature -- Element change

	set_input_output_path (a_input_path, a_output_path: EL_FILE_PATH)
		deferred
		end
end