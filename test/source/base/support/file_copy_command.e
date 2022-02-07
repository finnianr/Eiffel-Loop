note
	description: "File copy command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 8:01:27 GMT (Monday 7th February 2022)"
	revision: "4"

class
	FILE_COPY_COMMAND

inherit
	EL_FILE_INPUT_OUTPUT_COMMAND
		rename
			make_default as make,
			default_description as description
		end

	EL_MODULE_FILE

create
	make

feature -- Basic operations

	execute
		require else
			input_exists: input_path.exists
		   output_directory_exists: output_path.parent.exists
		local
			input_file: RAW_FILE
		do
			create input_file.make_with_name (input_path)
			File.copy_contents (input_file, output_path)
		end
end