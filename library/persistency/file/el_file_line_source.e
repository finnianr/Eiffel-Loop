note
	description: "Summary description for {EL_FILE_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-16 17:53:57 GMT (Tuesday 16th September 2014)"
	revision: "4"

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
			default_create
		end

create
	default_create, make, make_latin_1, make_from_file

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			create text_file.make_with_name ("any")
		end

	make (a_file_path: EL_FILE_PATH)
		do
			default_create
			create text_file.make_with_name (a_file_path)
			make_from_file (text_file)
			is_source_external := False -- Causes file to close automatically when after position is reached
		end

	make_latin_1 (a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			set_latin_encoding (1)
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
