note
	description: "File input output os command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 11:48:57 GMT (Tuesday 11th September 2018)"
	revision: "1"

class
	FILE_INPUT_OUTPUT_OS_COMMAND

inherit
	EL_OS_COMMAND

	EL_FILE_INPUT_OUTPUT_COMMAND_I

create
	make

feature -- Element change

	set_input_output_path (a_input_path, a_output_path: EL_FILE_PATH)
		do
			put_path (Var_input_path, a_input_path)
			put_path (Var_output_path, a_output_path)
		end

feature {NONE} -- Constants

	Var_input_path: ZSTRING
		once
			Result := "input_path"
		end

	Var_output_path: ZSTRING
		once
			Result := "output_path"
		end
end
