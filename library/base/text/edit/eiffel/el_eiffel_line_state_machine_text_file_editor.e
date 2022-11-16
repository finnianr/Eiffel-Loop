note
	description: "Eiffel line state machine text file editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR

inherit
	EL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		rename
			file_path as source_path
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

	new_input_lines (a_file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make (Latin_1, a_file_path)
		end

end