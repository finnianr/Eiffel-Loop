note
	description: "Text file editor with output in a separate file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "2"

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
