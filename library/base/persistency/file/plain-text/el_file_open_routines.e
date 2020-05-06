note
	description: "File open routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 10:07:22 GMT (Wednesday 6th May 2020)"
	revision: "2"

deferred class
	EL_FILE_OPEN_ROUTINES

inherit
	EL_ANY_SHARED

feature {NONE} -- Basic operations

	frozen close_open
		-- close file most recently opened with `open'
		do
			if Open_stack.count > 0 then
				if not Open_stack.item.is_closed then
					Open_stack.item.close
				end
				Open_stack.remove
			end
		end

	frozen close_all_open
		-- close all files recently opened with `open'
		do
			from until Open_stack.is_empty loop
				close_open
			end
		end

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
		require
			valid_encoding: encoding = Utf_8 or else (<< Windows, Latin >>).has (encoding & Encoding_id_mask)
			valid_windows: encoding & Encoding_id_mask = Windows implies valid_windows (encoding)
			valid_latin: encoding & Encoding_id_mask = Latin implies valid_latin (encoding)
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_with_name (path)
			if file.exists then
				file.open_read
				create Result.make_from_file (file)
				if encoding = Utf_8 then
					Result.set_utf_encoding (8)
				elseif (encoding & Windows).to_boolean then
					Result.set_windows_encoding (encoding & Encoding_id_mask)
				elseif (encoding & Latin).to_boolean then
					Result.set_latin_encoding (encoding & Encoding_id_mask)
				end
				if Result.is_open then
					Open_stack.put (Result.file)
				end
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
			if not file.is_closed then
				Open_stack.put (file)
			end
		end

feature {NONE} -- Status query

	frozen all_closed: BOOLEAN
		do
			Result := Open_stack.is_empty
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

	frozen valid_latin (encoding: NATURAL): BOOLEAN
		do
			inspect encoding & Encoding_id_mask
				when 1 .. 11, 13 .. 15 then
					Result := True
			else
			end
		end

	frozen valid_windows (encoding: NATURAL): BOOLEAN
		do
			inspect encoding & Encoding_id_mask
				when 1250 .. 1258 then
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

feature {NONE} -- Encoding types

	Latin: NATURAL = 0x1000

	Utf_8: NATURAL = 0x3008

	Windows: NATURAL = 0x2000

	Encoding_type_mask: NATURAL = 0xFFF

	Encoding_id_mask: NATURAL = 0xF000

feature {NONE} -- Constants

	Open_stack: ARRAYED_STACK [FILE]
		once
			create Result.make (5)
		end

end
