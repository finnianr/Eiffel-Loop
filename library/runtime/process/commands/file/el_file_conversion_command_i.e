note
	description: "Command that converts files from one type to anothers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_FILE_CONVERSION_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path
		redefine
			input_file_path, output_file_path,
			set_input_file_path, set_output_file_path
		end

feature -- Access

	input_file_path: FILE_PATH

	output_file_path: FILE_PATH

feature -- Element change

	set_input_file_path (a_input_file_path: like input_file_path)
		require else
			valid_extension: valid_input_extension (a_input_file_path.extension)
		do
			input_file_path := a_input_file_path
		end

	set_output_file_path (a_output_file_path: like output_file_path)
			--
		require else
			valid_extension: valid_output_extension (a_output_file_path.extension)
		do
			output_file_path := a_output_file_path
		end

feature -- Contract Support

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := True
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := True
		end

end