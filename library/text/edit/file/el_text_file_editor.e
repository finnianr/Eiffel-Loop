note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "6"

deferred class
	EL_TEXT_FILE_EDITOR

inherit
	EL_TEXT_EDITOR
		rename
			set_source_text_from_file as set_input_file_path
		export
			{NONE} all
			{ANY} set_input_file_path, edit_text, set_pattern_changed
		end

feature -- Element change

	set_output_file_path (an_output_file_path: like output_file_path)
			--
		do
			output_file_path := an_output_file_path
		end

feature {NONE} -- Implementation

	new_output: PLAIN_TEXT_FILE
			--
		do
			create Result.make_open_write (output_file_path)
		end

	output_file_path: EL_FILE_PATH

end
