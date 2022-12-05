note
	description: "[
		Command that takes a file input and outputs a file when `execute' is called
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 9:16:21 GMT (Monday 5th December 2022)"
	revision: "4"

deferred class
	EL_FILE_INPUT_OUTPUT_COMMAND

inherit
	EL_FILE_INPUT_OUTPUT_COMMAND_I

feature {NONE} -- Initialization

	make_default
		do
			create input_path
			create output_path
		end

feature -- Element change

	set_input_output_path (a_input_path, a_output_path: FILE_PATH)
		do
			input_path := a_input_path; output_path := a_output_path
		end

feature -- Access

	input_path: FILE_PATH

	output_path: FILE_PATH

end