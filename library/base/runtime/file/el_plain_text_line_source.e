note
	description: "[
		Iterates over lines of a plain text file lines using either the [$source ITERABLE [G]] or
		[$source LINEAR [G]] interface. If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 12:13:57 GMT (Tuesday 6th December 2022)"
	revision: "30"

class
	EL_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_FILE_GENERAL_LINE_SOURCE [ZSTRING]
		rename
			make as make_from_file
		export
			{ANY} file
		redefine
			read_line, set_file, new_list, Default_file
		end

	EL_EVENT_LISTENER
		rename
			notify as on_encoding_update
		end

create
	make_default, make, make_from_file, make_utf_8, make_encoded

feature {NONE} -- Initialization

	make_encoded (nonstandard_encoding: ENCODING; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_encoded_from_path (Other_class, nonstandard_encoding, a_path)
		end

	make (encoding_code: NATURAL; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_encoded_from_path (encoding_code, Void, a_path)
		end

	make_utf_8 (a_path: READABLE_STRING_GENERAL)
		do
			make_encoded_from_path (Utf_8, Void, a_path)
		end

	make_encoded_from_path (encoding_code: NATURAL; a_encoding: detachable ENCODING; a_path: READABLE_STRING_GENERAL)
		require
			valid_code: attached a_encoding implies encoding_code = Other_class
		do
			make_from_file (new_file (encoding_code, a_path))
			if encoding_detected then
				on_encoding_update

			elseif attached a_encoding as l_encoding then
				file.set_other_encoding (l_encoding)
				set_other_encoding (l_encoding)
			else
				file.set_encoding (encoding_code)
				set_encoding (encoding_code)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
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

	new_file (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL): like default_file
		do
			create Result.make_with_name (a_path)
		end

	new_list (n: INTEGER): EL_ZSTRING_LIST
		do
			create Result.make (n)
		end

	on_encoding_update
		do
			if not file.encoding_detected then
				file.set_encoding_from_other (Current)
			end
		end

	read_line (f: like Default_file)
		do
			f.read_line
		end

	set_file (a_file: like file)
		do
			Precursor (a_file)
			if a_file.encoding_detected then
				set_encoding_from_other (a_file)
				encoding_detected := True
			end
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