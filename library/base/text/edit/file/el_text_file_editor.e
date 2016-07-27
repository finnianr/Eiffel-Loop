note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 15:21:03 GMT (Thursday 7th July 2016)"
	revision: "8"

deferred class
	EL_TEXT_FILE_EDITOR

inherit
	EL_TEXT_EDITOR
		rename
			set_source_text_from_file as set_input_file_path
		export
			{NONE} all
			{ANY} set_input_file_path, edit, set_pattern_changed
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
			Result.set_encoding_from_other (Current)
			Result.enable_bom
			Result.put_bom
		end

	output_file_path: EL_FILE_PATH

end