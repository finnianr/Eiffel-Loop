note
	description: "[
		Encoded source text read from file as ${ZSTRING} lines or set externally
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:11:28 GMT (Sunday 25th August 2024)"
	revision: "7"

class
	EL_FILE_SOURCE_TEXT

inherit
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
			source_file_path := Default_file_path
		end

feature -- Element Change

	set_source_text (a_source_text: ZSTRING)
		do
			source_text := a_source_text
		end

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

feature {NONE} -- Implementation

	new_input_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make (encoding, file_path)
			Result.enable_shared_item
		end

feature {NONE} -- Internal attributes

	source_file_path: FILE_PATH

	source_text: ZSTRING

feature {NONE} -- Constants

	Default_file_path: FILE_PATH
		once
			create Result
		end

end