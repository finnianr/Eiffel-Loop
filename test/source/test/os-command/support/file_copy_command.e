note
	description: "File copy command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-10 14:22:20 GMT (Monday 10th September 2018)"
	revision: "1"

class
	FILE_COPY_COMMAND

inherit
	EL_FILE_INPUT_OUTPUT_COMMAND
		rename
			make_default as make
		end

	EL_MODULE_FILE_SYSTEM

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
			File_system.copy_file_contents (input_file, output_path)
		end
end
