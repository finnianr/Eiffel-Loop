note
	description: "File input output os command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	FILE_INPUT_OUTPUT_OS_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [input_path, output_path: STRING]]

	EL_FILE_INPUT_OUTPUT_COMMAND_I
		undefine
			is_equal
		end

create
	make_command

feature -- Element change

	set_input_output_path (a_input_path, a_output_path: FILE_PATH)
		do
			put_path (Var.input_path, a_input_path)
			put_path (Var.output_path, a_output_path)
		end

feature {NONE} -- Constants

	Template: STRING = ""
end