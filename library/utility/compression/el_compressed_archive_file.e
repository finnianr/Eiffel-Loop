note
	description: "Compressed archive file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_COMPRESSED_ARCHIVE_FILE

inherit
	RAW_FILE
		rename
			append_file as append_file_contents
		export
			{NONE} all
			{ANY} close, last_string, name, start, end_of_file, position,
				is_closed, is_open_read, is_open_write, path, date,
				open_read, open_write, make_open_write, make_open_read
		redefine
			make_with_name, after, off
		end

	EL_FILE_OPEN_ROUTINES
		rename
			Append as Append_to
		end

	EL_MODULE_CHECKSUM; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_MODULE_ZLIB

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

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
			create last_data.make_empty (0)
			enable_checksum
			level := 9
			expected_compression_ratio := 0.4
		end

feature -- Access

	file_list: EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [INTEGER, FILE_PATH]
		require
			open_read: is_open_read and then position = 0
		local
			done: BOOLEAN
		do
			file_count := 0
			create Result.make (100)
			from start until after or done loop
				read_file_name
				if last_file_path.is_empty then
					done := True
				else
					read_content_size
					Result.extend (last_uncompressed_count, last_file_path)
				end
			end
		end

	last_file_path: FILE_PATH

	last_data: SPECIAL [NATURAL_8]
		-- data read by `read_compressed_file'

	last_uncompressed_count: INTEGER

feature -- Measurement

	expected_compression_ratio: DOUBLE

	file_count: INTEGER

	level: INTEGER

feature -- Element change

	set_expected_compression_ratio (a_expected_compression_ratio: DOUBLE)
		do
			expected_compression_ratio := a_expected_compression_ratio
		end

	set_level (a_level: INTEGER)
		do
			level := a_level
		end

feature -- Status change

	disable_checksum
		do
			is_checksum_enabled := False
		end

	enable_checksum
		do
			is_checksum_enabled := True
		end

feature -- Status query

	is_checksum_enabled: BOOLEAN

	is_last_data_ok: BOOLEAN
		-- `True' if `last_data' was read without error

feature -- Basic operations

	append_file_list (list: ITERABLE [FILE_PATH])
		require
			open_append: is_open_write
			files_exists: across list as l all l.item.exists end
			valid_expected_compression_ratio: expected_compression_ratio > 0.0
			valid_level: level > 0
		do
			across list as l_path loop
				progress_listener.increase_file_data_estimate (l_path.item)
			end
			across list as l_path loop
				append_file (l_path.item)
			end
			progress_listener.finish
		end

	decompress_all (handler: EL_FILE_DECOMPRESS_HANDLER)
		require
			open_read: is_open_read and then position = 0
		local
			done: BOOLEAN
		do
			file_count := 0
			if attached file_list as list then
				from list.start until list.after loop
					progress_listener.increase_data_estimate (list.item_key)
					list.forth
				end
			end
			from start until after or done loop
				read_file_name
				if last_file_path.is_empty then
					done := True
				else
					read_compressed_file (handler)
				end
			end
			progress_listener.finish
		end

	write_last_data (a_file_path: FILE_PATH)
		-- write content of `last_data' to file `a_file_path'
		do
			if attached open_raw (a_file_path, Write) as output_file then
				Data_pointer.set_from_pointer (last_data.base_address, last_data.count)
				output_file.put_managed_pointer (Data_pointer, 0, last_data.count)
				output_file.close
			end
		end

feature {NONE} -- Implementation

	append_file (a_file_path: FILE_PATH)
		require
			open_append: is_open_write
		local
			file_data: MANAGED_POINTER; compressed_data: SPECIAL [NATURAL_8]
			utf8_path: STRING; l_checksum: NATURAL
		do
			file_data := File.data (a_file_path)
			if is_checksum_enabled then
				l_checksum := Checksum.data (file_data)
			end
			compressed_data := Zlib.compressed (file_data, level, expected_compression_ratio)

			utf8_path := a_file_path.to_string.to_utf_8 (True)
			put_integer (utf8_path.count)
			put_string (utf8_path)

			put_integer (file_data.count)
			put_integer (compressed_data.count)
			if is_checksum_enabled then
				put_natural (l_checksum)
			end
			Data_pointer.set_from_pointer (compressed_data.base_address, compressed_data.count)
			put_managed_pointer (Data_pointer, 0, Data_pointer.count)
			progress_listener.on_notify (file_data.count)
		end

	read_compressed_file (handler: EL_FILE_DECOMPRESS_HANDLER)
			-- results available in last_string
		require
			open_read: is_open_read
		local
			compressed_data: MANAGED_POINTER; l_checksum, actual_checksum: NATURAL
		do
			read_integer
			last_uncompressed_count := last_integer
			if is_lio_enabled then
				lio.put_integer_field ("READ: last_uncompressed_count", last_uncompressed_count)
			end
			read_integer
			create compressed_data.make (last_integer)
			if is_checksum_enabled then
				read_natural
				l_checksum := last_natural
			end
			if is_lio_enabled then
				lio.put_integer_field (" compressed_data.count", compressed_data.count)
			end
			read_to_managed_pointer (compressed_data, 0, compressed_data.count)
			last_data := Zlib.decompressed (compressed_data, last_uncompressed_count)
			if is_checksum_enabled then
				Data_pointer.set_from_pointer (last_data.base_address, last_data.count)
				actual_checksum := Checksum.data (Data_pointer)
				if is_lio_enabled then
					lio.put_string_field (" actual_checksum", actual_checksum.out)
				end
				is_last_data_ok := l_checksum = actual_checksum
				if is_last_data_ok then
					handler.on_decompressed (Current, file_count + 1)
					progress_listener.on_notify (last_uncompressed_count)
				else
					handler.on_decompression_error (last_file_path, True)
				end
				if is_lio_enabled then
					if is_last_data_ok then
						lio.put_string (" OK")
					else
						lio.put_string (" ERROR")
					end
					lio.put_new_line
				end
			else
				is_last_data_ok := True
				handler.on_decompressed (Current, file_count + 1)
				progress_listener.on_notify (last_uncompressed_count)
			end
			file_count := file_count + 1
		end

	read_content_size
		local
			compressed_data_count: INTEGER
		do
			read_integer
			last_uncompressed_count := last_integer
			read_integer
			compressed_data_count := last_integer
			if is_checksum_enabled then
				read_natural
			end
			move (compressed_data_count)
			file_count := file_count + 1
		end

	read_file_name
		require
			open_read: is_open_read
		local
			file_name_count: INTEGER
			l_file_path: ZSTRING
		do
			if (count - position) > {PLATFORM}.Integer_32_bytes then
				read_integer
				file_name_count := last_integer
				if (count - position) > file_name_count
					and then 4 <= file_name_count and file_name_count <= Maximum_file_name_count
				then
					read_stream (file_name_count)
					create l_file_path.make_from_utf_8 (last_string)
					last_file_path := l_file_path
					if is_lio_enabled then
						lio.put_path_field ("Read", last_file_path)
						lio.put_new_line
					end
				else
					create last_file_path
				end
			else
				create last_file_path
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

feature {NONE} -- Constants

	Data_pointer: MANAGED_POINTER
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end

	Maximum_file_name_count: INTEGER
		once
			Result := 500
		end
end