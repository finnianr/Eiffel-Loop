note
	description: "File open routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 8:14:53 GMT (Thursday 10th February 2022)"
	revision: "6"

deferred class
	EL_FILE_OPEN_ROUTINES

inherit
	EL_ENCODING_CONSTANTS
		rename
			Other as Other_class,
			Latin as Latin_class,
			Utf as Utf_class,
			Windows as Windows_class
		end

feature {NONE} -- Basic operations

	frozen open (path: READABLE_STRING_GENERAL; mode: NATURAL): EL_PLAIN_TEXT_FILE
		require
			valid_mode: valid_file_mode (mode)
		do
			if (mode & Notifying).to_boolean then
				create {EL_NOTIFYING_PLAIN_TEXT_FILE} Result.make_with_name (path)
			else
				create Result.make_with_name (path)
			end
			open_file (Result, mode)
		end

	frozen open_lines (path: READABLE_STRING_GENERAL; encoding: NATURAL): EL_PLAIN_TEXT_LINE_SOURCE
		-- open file for reading using LINEAR iterator
		require
			valid_encoding: valid_encoding (encoding)
		local
			file_path: FILE_PATH
		do
			create file_path.make (path)
			if file_path.exists then
				create Result.make (encoding, path)
			else
				create Result.make_default
			end
		end

	frozen open_raw (path: READABLE_STRING_GENERAL; mode: NATURAL): RAW_FILE
		require
			valid_mode: valid_file_mode (mode)
		do
			if (mode & Notifying).to_boolean then
				create {EL_NOTIFYING_RAW_FILE} Result.make_with_name (path)
			else
				create Result.make_with_name (path)
			end
			open_file (Result, mode)
		end

feature {NONE} -- Implementation

	frozen open_file (file: FILE; mode: NATURAL)
		require
			valid_mode: valid_file_mode (mode)
		do
			if (mode & Read).to_boolean then
				if (mode & Append).to_boolean then
					file.open_read_append

				elseif (mode & Write).to_boolean then
					if (mode & Create_).to_boolean then
						file.create_read_write
					else
						file.open_read_write
					end
				elseif file.exists then
					file.open_read
				end
			elseif (mode & Write).to_boolean then
				file.open_write
			elseif (mode & Append).to_boolean then
				file.open_append
			end
		end

feature {NONE} -- Contract Support

	frozen valid_file_mode (mode: NATURAL): BOOLEAN
		do
			inspect mode
				when Append, Closed, Create_, Notifying, Read, Write then
					Result := True
			else
			end
		end

feature {NONE} -- Mode bitmaps

	Append: NATURAL = 1

	Closed: NATURAL = 0

	Create_: NATURAL = 2

	Notifying: NATURAL = 16

	Read: NATURAL = 4

	Write: NATURAL = 8

end