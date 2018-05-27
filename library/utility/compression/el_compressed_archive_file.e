note
	description: "Compressed archive file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_COMPRESSED_ARCHIVE_FILE

inherit
	RAW_FILE
		rename
			append_file as append_file_contents
		export
			{NONE} all
			{ANY} close, last_string, name, start, end_of_file, position,
				is_closed, is_open_read, is_open_write
		redefine
			make_with_name, after, off
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_ZLIB

create
	make_open_write, make_open_read, make_default

feature {NONE} -- Initialization

	make_default
		do
			make_with_name ("none")
		end

	make_with_name (fn: READABLE_STRING_GENERAL)
			-- Create file object with `fn' as file name
		do
			Precursor (fn)
			create last_file_path
			create last_managed_pointer.share_from_pointer (Default_pointer, 0)
			create crc_32
			enable_checksum
		end

feature -- Access

	extracted_count: INTEGER

	last_file_path: EL_FILE_PATH

	last_managed_pointer: MANAGED_POINTER

feature -- Element change

	append_file (a_file_path: EL_FILE_PATH; expected_compression_ratio: DOUBLE; level: INTEGER)
		require
			open_append: is_open_write
		local
			file_data: MANAGED_POINTER; compressed_data, utf8_path: STRING
		do
			file_data := File_system.file_data (a_file_path)
			if is_checksum_enabled then
				crc_32.reset
				crc_32.add_data (file_data)
			end
			compressed_data := Zlib.compress (file_data, expected_compression_ratio, level)

			utf8_path := a_file_path.to_string.to_utf_8
			put_integer (utf8_path.count)
			put_string (utf8_path)

			put_integer (file_data.count)
			put_integer (compressed_data.count)
			if is_checksum_enabled then
				put_natural (crc_32.checksum)
			end
			put_string (compressed_data)
		end

feature -- Status change

	enable_checksum
		do
			is_checksum_enabled := True
		end

	disable_checksum
		do
			is_checksum_enabled := False
		end

feature -- Input

	read_compressed_file
			-- results available in last_string
		require
			open_read: is_open_read
		local
			uncompressed_count: INTEGER; compressed_data: MANAGED_POINTER; check_sum: NATURAL
		do
			read_integer
			uncompressed_count := last_integer
			if is_lio_enabled then
				lio.put_integer_field ("READ: uncompressed_count", uncompressed_count)
			end
			read_integer
			create compressed_data.make (last_integer)
			if is_checksum_enabled then
				read_natural
				check_sum := last_natural
			end
			if is_lio_enabled then
				lio.put_integer_field (" compressed_data.count", compressed_data.count)
			end
			read_to_managed_pointer (compressed_data, 0, compressed_data.count)
			last_string := Zlib.uncompress (compressed_data, uncompressed_count)
			last_managed_pointer.set_from_pointer (last_string.area.base_address, last_string.count)
			if is_checksum_enabled then
				crc_32.reset
				crc_32.add_data (last_managed_pointer)
				if is_lio_enabled then
					lio.put_string_field (" crc.checksum", crc_32.checksum.out)
				end
				is_last_managed_pointer_ok := check_sum = crc_32.checksum
				if is_lio_enabled then
					if is_last_managed_pointer_ok then
						lio.put_string (" OK")
					else
						lio.put_string (" ERROR")
					end
					lio.put_new_line
				end
			else
				is_last_managed_pointer_ok := True
			end
			extracted_count := extracted_count + 1
		end

	read_file_name
		require
			open_read: is_open_read
		local
			file_name_count: INTEGER
			l_file_path: ZSTRING
		do
			read_integer
			file_name_count := last_integer
			if file_name_count < count - 4 then
				read_stream (file_name_count)
				create l_file_path.make_from_utf_8 (last_string)
				last_file_path := l_file_path
			end
			if is_lio_enabled then
				lio.put_path_field ("Read", last_file_path)
				lio.put_new_line
			end
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor position?
		do
			Result := not is_closed and then count = position
		end

	off: BOOLEAN
			-- Is there no item?
		do
			Result := (count = 0) or else is_closed or else count = position
		end

	is_checksum_enabled: BOOLEAN

	is_last_managed_pointer_ok: BOOLEAN

feature {NONE} -- Implementation

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end
