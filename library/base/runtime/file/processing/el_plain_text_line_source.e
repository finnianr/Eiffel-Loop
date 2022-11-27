note
	description: "[
		Iterates over lines of a plain text file lines using either the [$source ITERABLE [G]] or
		[$source LINEAR [G]] interface. If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-27 9:29:03 GMT (Sunday 27th November 2022)"
	revision: "29"

class
	EL_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_FILE_GENERAL_LINE_SOURCE [ZSTRING]
		rename
			make as make_from_file,
			encoding as encoding_code
		export
			{ANY} file
		redefine
			check_encoding, read_line, set_file, new_list, Default_file
		end

	EL_MODULE_FILE
		rename
			File as Mod_file
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

create
	make_default, make, make_from_file, make_utf_8, make_encoded

feature {NONE} -- Initialization

	make_encoded (a_encoding: ENCODING; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_from_file (new_file (Other_class, a_path))
			if not encoding_detected then
				file.set_other_encoding (a_encoding)
				set_other_encoding (a_encoding)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

	make (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_from_file (new_file (a_encoding, a_path))
			if not encoding_detected then
				file.set_encoding (a_encoding)
				set_encoding (a_encoding)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

	make_utf_8 (a_path: READABLE_STRING_GENERAL)
		do
			make (Utf_8, a_path)
		end

feature -- Access

	byte_count: INTEGER
		do
			Result := file.count
		end

	date: INTEGER
		do
			Result := file.date
		end

	file_path: FILE_PATH
		do
			Result := file.path
		end

feature {NONE} -- Implementation

	check_encoding
		do
			if file.byte_order_mark.is_enabled then
				file.open_read
				if file.encoding_detected then
					set_encoding (file.encoding)
					encoding_detected := file.encoding_detected
					bom_count := file.bom_count
				end
			else
				Precursor
			end
		end

	new_file (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL): like default_file
		do
			create Result.make_with_name (a_path)
		end

	new_list (n: INTEGER): EL_ZSTRING_LIST
		do
			create Result.make (n)
		end

	read_line (f: like Default_file)
		do
			f.read_line
		end

	set_file (a_file: like file)
		do
			file := a_file
			set_encoding (a_file.encoding)
		end

	update_item
		do
			if is_shared_item then
				item := file.last_string
			else
				item := file.last_string.twin
			end
		end

feature {NONE} -- Constants

	Default_file: EL_PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("default.txt")
		end
end