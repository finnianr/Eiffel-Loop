note
	description: "Summary description for {EL_FILE_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-11 9:53:53 GMT (Saturday 11th June 2016)"
	revision: "6"

class
	EL_FILE_LINE_SOURCE

inherit
	EL_LINE_SOURCE [PLAIN_TEXT_FILE]
		rename
			make as make_from_file,
			make_latin_1 as make_latin_1_encoding,
			source as text_file
		export
			{ANY} text_file
		redefine
			make_default
		end

create
	make_default, make, make_encoded, make_latin, make_from_file, make_windows

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create text_file.make_with_name ("any")
		end

	make (a_file_path: EL_FILE_PATH)
		do
			make_default -- UTF-8 by default
			create text_file.make_with_name (a_file_path)
			make_from_file (text_file)
			is_source_external := False -- Causes file to close automatically when after position is reached
		end

	make_encoded (encodeable: EL_ENCODEABLE_AS_TEXT; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_encoding_from_other (encodeable)
			end
		end

	make_latin (a_encoding: INTEGER; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_latin_encoding (a_encoding)
			end
		end

	make_windows (a_encoding: INTEGER; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_windows_encoding (a_encoding)
			end
		end

feature -- Access

	byte_count: INTEGER
		do
			Result := text_file.count
		end

	file_path: EL_FILE_PATH
		do
			Result := text_file.path
		end

	date: INTEGER
		do
			Result := text_file.date
		end

feature -- Status setting

	delete_file
			--
		do
			if text_file.is_open_read then
				text_file.close
			end
			text_file.delete
		end

end
