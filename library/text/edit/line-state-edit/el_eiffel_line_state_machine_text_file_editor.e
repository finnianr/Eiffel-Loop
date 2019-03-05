note
	description: "Eiffel line state machine text file editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 14:10:14 GMT (Tuesday 5th March 2019)"
	revision: "5"

deferred class
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR

inherit
	EL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		undefine
			is_bom_enabled
		redefine
			new_input_lines
		end

	EL_EIFFEL_SOURCE_EDITOR
		undefine
			make_default, edit
		end

feature {NONE} -- Implementation

	new_input_lines (a_file_path: like file_path): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_latin (1, a_file_path)
		end

end
