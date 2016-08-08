note
	description: "Parsing text file editor with output to a separate file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_FILE_PARSER_TEXT_FILE_CONVERTER

inherit
	EL_FILE_PARSER_TEXT_EDITOR
		rename
			file_path as input_file_path,
			set_file_path as set_input_file_path
		undefine
			new_output
		redefine
			make_default, input_file_path
		end

	EL_TEXT_FILE_CONVERTER
		undefine
			edit, Default_file_path
		redefine
			make_default, input_file_path
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			output_file_path := Default_file_path
			Precursor {EL_FILE_PARSER_TEXT_EDITOR}
		end

feature -- Access

	input_file_path: EL_FILE_PATH

end
