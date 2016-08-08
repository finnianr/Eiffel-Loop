note
	description: "Text file editor with output in a separate file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_TEXT_FILE_CONVERTER

inherit
	EL_TEXT_FILE_EDITOR
		rename
			file_path as input_file_path,
			set_file_path as set_input_file_path
		redefine
			make_default, new_output
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			output_file_path := Default_file_path
		end

feature -- Element change

	set_output_file_path (an_output_file_path: like output_file_path)
			--
		do
			output_file_path := an_output_file_path
		end

feature {NONE} -- Implementation

	new_output: EL_PLAIN_TEXT_FILE
			--
		do
			create Result.make_open_write (output_file_path)
		end

	output_file_path: EL_FILE_PATH

end
