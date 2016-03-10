note
	description: "Summary description for {EL_EIFFEL_TEXT_FILE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_EIFFEL_TEXT_FILE_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		undefine
			put_string
		end

	EL_EIFFEL_TEXT_EDITOR
		rename
			set_source_text_from_file as set_input_file_path
		end
end
