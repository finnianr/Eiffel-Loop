note
	description: "File parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "10"

deferred class
	EL_FILE_PARSER

inherit
	EL_PARSER
		export
			{NONE} all
			{ANY}	match_full, call_actions, is_reset, fully_matched, set_source_text, set_pattern_changed
		redefine
			make_default
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_ENCODEABLE_AS_TEXT}
			Precursor {EL_PARSER}
			source_file_path := Default_file_path
		end

feature -- Element Change

  	set_source_text_from_file (file_path: FILE_PATH)
 			--
 		do
 			set_source_text_from_line_source (new_input_lines (file_path))
 		end

	set_source_text_from_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
			--
		do
 			source_file_path := lines.file_path
 			set_encoding_from_other (lines) -- May have detected UTF-8 BOM
 			set_source_text (lines.joined)
		end

feature {NONE} -- Factory

 	new_input_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
 		do
 			create Result.make (encoding, file_path)
 			Result.enable_shared_item
 		end

feature {NONE} -- Internal attributes

	source_file_path: FILE_PATH

feature {NONE} -- Constants

	Default_file_path: FILE_PATH
		once
			create Result
		end

end