note
	description: "[
		Edit file by processing lines according to line state and putting output in `output_lines'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:17:26 GMT (Sunday 21st May 2017)"
	revision: "2"

deferred class
	EL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_TEXT_FILE_EDITOR
		redefine
			make_default, edit
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			make_machine
			create input_lines.make_default
			create output_lines.make_empty
			Precursor
		end

feature -- Access

	file_path: EL_FILE_PATH
		do
			Result := input_lines.file_path
		end

feature -- Element change

	set_file_path (a_file_path: like file_path)
			--
		do
			output_lines.wipe_out
			input_lines := new_input_lines (a_file_path)
			set_encoding_from_other (input_lines)
		end

feature -- Basic operations

	edit
		do
			do_once_with_file_lines (initial_state, input_lines)
			Precursor
		end

feature {NONE} -- Implementation

	initial_state: PROCEDURE [ZSTRING]
			-- initial line state procedure to use for `put_editions' (called from `edit')
		deferred
		end

	new_input_lines (a_file_path: like file_path): EL_FILE_LINE_SOURCE
		do
			create Result.make_encoded (Current, file_path)
		end

	put_editions
		do
			output.put_lines (output_lines)
		end

feature {NONE} -- Internal attributes

	input_lines: EL_FILE_LINE_SOURCE

	output_lines: EL_ZSTRING_LIST

end
