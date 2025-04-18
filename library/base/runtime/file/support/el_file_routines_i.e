note
	description: "File related routines accessible via ${EL_MODULE_FILE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:29:55 GMT (Wednesday 16th April 2025)"
	revision: "29"

deferred class
	EL_FILE_ROUTINES_I

inherit
	EL_OS_DEPENDENT

	EL_MODULE_FILE_SYSTEM

	NATIVE_STRING_HANDLER; EL_STRING_HANDLER

	EL_FILE_OPEN_ROUTINES

	EL_STRING_8_CONSTANTS

	EL_MODULE_CHECKSUM
		rename
			Checksum as Checksum_
		end

feature {NONE} -- Initialization

	make
		do
			create internal_info_file.make
		end

feature -- Access

	info (a_path: EL_PATH; keep_ref: BOOLEAN): EL_INFO_RAW_FILE
		do
			if keep_ref then
				create Result.make
			else
				Result := internal_info_file
			end
			Result.set_path (a_path)
		end

	new_plain_text (file_path: detachable FILE_PATH): PLAIN_TEXT_FILE
		do
			if attached file_path as path then
				create Result.make_with_name (path)
			else
				create Result.make_with_name ("None.txt")
			end
		end

feature -- Measurement

	access_time (file_path: FILE_PATH): INTEGER
		do
			Result := info (file_path, False).access_date
		end

	average_line_count (file_path: FILE_PATH): INTEGER
		require
			path_exists: file_path.exists
		do
			if file_path.exists and then attached open (file_path, Read) as file then
				if file.count > 0 then
					Result := file.average_line_count
				end
				file.close
			end
		end

	average_line_count_of (file: PLAIN_TEXT_FILE): INTEGER
		-- average characters per line based on leading 1K block
		require
			file_readable: file.readable
		local
			position, char_count, newline_count: INTEGER; pending_break, break: BOOLEAN
		do
			if attached {EL_PLAIN_TEXT_FILE} file as f then
			-- optimized to not use `last_character' and correctly counts UTF encoded characters
				Result := f.average_line_count
			else
			-- not accurate for UTF encoded files, but OK for Latin-1
				position := file.position
				file.go (0)
				from until break loop
					file.read_character
					if file.end_of_file then
						break := True
					else
						inspect file.last_character when '%N' then
							newline_count := newline_count + 1
							if pending_break then
								break := True
							end
						else
						end
						char_count := char_count + 1
						if char_count > 1024 then
							pending_break := True
						end
					end
				end
				Result := (char_count / newline_count.max (1)).rounded
				file.go (position)
			end
		ensure
			position_unchanged: file.position = old file.position
		end

	byte_count (file_path: FILE_PATH): INTEGER
			--
		do
			Result := info (file_path, False).count
		end

	checksum (file_path: FILE_PATH): NATURAL
		-- CRC-32 checksum
		do
			Result := Checksum_.file_content (file_path)
		end

	megabyte_count (file_path: FILE_PATH): DOUBLE
			--
		do
			Result := byte_count (file_path) / 1000000
		end

	modification_time (file_path: FILE_PATH): INTEGER
		do
			if attached info (file_path, False) as l_info and then l_info.exists then
				Result := l_info.date
			end
		end

feature -- File content

	data (file_path: FILE_PATH): MANAGED_POINTER
		require
			file_exists: file_path.exists
		do
			if attached open_raw (file_path, Read) as file then
				create Result.make (file.count)
				file.read_to_managed_pointer (Result, 0, file.count)
				file.close
			end
		end

	line_one (file_path: FILE_PATH): STRING
		-- First line of file
		require
			file_exists: file_path.exists
		do
			if attached open (file_path, Read) as file then
				if file.is_empty then
					create Result.make_empty
				else
					file.read_line
					Result := file.last_string
					if {PLATFORM}.is_unix then
						Result.prune_all_trailing ('%R')
					end
				end
				file.close
			end
		end

	plain_text (file_path: FILE_PATH): STRING
		-- plain text excluding any Windows carriage return characters '%R'
		do
			Result := raw_plain_text (file_path)
			if {PLATFORM}.is_unix and then has_windows_line_break (Result) then
				Result.prune_all ('%R')
			end
			Result.right_adjust
		end

	plain_text_bomless (file_path: FILE_PATH): READABLE_STRING_8
		-- file text without any byte-order mark
		local
			utf: EL_UTF_CONVERTER
		do
			Result := plain_text (file_path)
			if utf.is_utf_8_file (Result) then
				Result := utf.bomless_utf_8 (Result)

			elseif utf.is_utf_16_le_file (Result) then
				Result := utf.bomless_utf_16_le (Result)

			end
		end

	plain_text_lines (file_path: FILE_PATH): EL_ITERABLE_SPLIT [STRING_8, CHARACTER_8, ANY]
		require
			file_exists: file_path.exists
		do
			if attached raw_plain_text (file_path) as content then
				content.right_adjust
				if {PLATFORM}.is_unix and then has_windows_line_break (content) then
					-- Check if content has Windows carriage return
					create {EL_SPLIT_STRING_8_ON_STRING [STRING]} Result.make (content, "%R%N")

				else
					create {EL_SPLIT_ON_CHARACTER_8 [STRING]} Result.make (content, '%N')
				end
			else
				create {EL_SPLIT_ON_CHARACTER_8 [STRING]} Result.make (Empty_string_8, '%N')
			end
		end

	raw_plain_text (file_path: FILE_PATH): STRING
		-- plain text possibly containing '%R' on Unix platforms
		require
			file_exists: file_path.exists
		local
			file: PLAIN_TEXT_FILE; read_count, count: INTEGER
		do
			create file.make_open_read (file_path)
			count := file.count
			create Result.make (count)
			Result.set_count (count)
			read_count := file.read_to_string (Result, 1, count)
			Result.set_count (read_count)

			if {PLATFORM}.is_windows then
				-- which condition applies probably depends on whether the file has Unix or Windows line endings
				check
					complete_file_read: count = read_count or else (count - (read_count + Result.occurrences ('%N'))) <= 2
				end
			else
				check
					complete_file_read: read_count = count
				end
			end
			file.close
		end

feature -- Status report

	exists (a_path: EL_PATH): BOOLEAN
		do
			Result := info (a_path, False).exists
		end

	has_content (file_path: FILE_PATH): BOOLEAN
			-- True if file not empty
		do
			if attached open_raw (file_path, Read) as file then
				Result := not file.is_empty
				file.close
			end
		end

	has_utf_8_bom (file_path: FILE_PATH): BOOLEAN
		do
			if attached new_plain_text (file_path) as text then
				text.open_read
				Result := has_utf_8_bom_marker (text)
				text.close
			end
		end

	has_utf_8_bom_marker (file: PLAIN_TEXT_FILE): BOOLEAN
		require
			file_open: file.is_open_read
			at_start_position: file.position = 0
		local
			bom: STRING
		do
			bom := {UTF_CONVERTER}.Utf_8_bom_to_string_8
			if file.count >= bom.count then
				file.read_stream (bom.count)
				Result := file.last_string ~ bom
			end
		end

	has_windows_line_break (content: STRING): BOOLEAN
		-- True if `content' contains `%R%N'
		local
			index: INTEGER
		do
			index := content.index_of ('%N', 1)
			Result := index > 1 and then content [index - 1] = '%R'
		end

	is_access_owner (a_path: EL_PATH): BOOLEAN
		do
			Result := info (a_path, False).is_access_owner
		end

	is_access_writable (a_path: FILE_PATH): BOOLEAN
		do
			Result := info (a_path, False).is_access_writable
		end

	is_newer_than (path_1, path_2: FILE_PATH): BOOLEAN
		-- `True' if either A or B is true
		-- A. `path_1' modification time is greater than `path_2' modification time
		-- B. `path_2' does not exist
		require
			path_1_exists: path_1.exists
		do
			Result := not path_2.exists or else modification_time (path_1) > modification_time (path_2)
		end

	is_owner (a_path: FILE_PATH): BOOLEAN
		do
			Result := info (a_path, False).is_owner
		end

	is_readable (a_path: FILE_PATH): BOOLEAN
		deferred
		end

	is_symlink (path: EL_PATH): BOOLEAN
		-- `True' if file is a symbolic link
		-- (Does not seem to work for "C:\Users\Default User" on 16.05)
		do
			Result := info (path, False).is_symlink
		end

	is_writable (a_path: FILE_PATH): BOOLEAN
		deferred
		end

feature -- Property change

	add_permission (path: FILE_PATH; who, what: STRING)
			-- Add read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		require
			file_exists: path.exists
			valid_who: valid_who (who)
			valid_what: valid_what (what)
		do
			change_permission (path, who, what, agent {FILE}.add_permission)
		end

	remove_permission (path: FILE_PATH; who, what: STRING)
			-- remove read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		require
			file_exists: path.exists
			valid_who: valid_who (who)
			valid_what: valid_what (what)
		do
			change_permission (path, who, what, agent {FILE}.remove_permission)
		end

	set_modification_time (file_path: FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		deferred
		ensure
			modification_time_set: modification_time (file_path) = date_time
		end

	set_stamp (file_path: FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		deferred
		ensure
			file_access_time_set: access_time (file_path) = date_time
			modification_time_set: modification_time (file_path) = date_time
		end

feature -- Basic operations

	copy_contents (source_file: FILE; destination_path: FILE_PATH)
		require
			exists_and_closed: source_file.is_closed and source_file.exists
		local
			destination_file: FILE; file_data: MANAGED_POINTER
			l_byte_count: INTEGER
		do
			File_system.make_directory (destination_path.parent)
			destination_file := source_file.twin
			source_file.open_read
			l_byte_count := source_file.count
			-- Read
			create file_data.make (l_byte_count)
			source_file.read_to_managed_pointer (file_data, 0, l_byte_count)
			notify_progress (source_file, False)
			source_file.close
			-- Write
			destination_file.make_open_write (destination_path)
			destination_file.put_managed_pointer (file_data, 0, l_byte_count)
			notify_progress (destination_file, True)
			destination_file.close
		end

	copy_contents_to_dir (source_file: FILE; destination_dir: DIR_PATH)
		local
			destination_path: FILE_PATH
		do
			destination_path := source_file.path
			destination_path.set_parent (destination_dir)
			copy_contents (source_file, destination_path)
		end

	do_with_all_blocks (file_path: FILE_PATH; action: PROCEDURE [MANAGED_POINTER]; block_size: INTEGER)
		-- call `action' with consective data blocks of maximum `block_size' bytes for entire file at `file_path'
		do
			do_with_blocks (file_path, action, 0, block_size)
		end

	do_with_blocks (file_path: FILE_PATH; action: PROCEDURE [MANAGED_POINTER]; max_byte_count, block_size: INTEGER)
		-- call `action' with consective data blocks of maximum `block_size' bytes for entire file at `file_path'
		-- but if `max_byte_count > 0' then limit to first `max_byte_count' bytes

		-- NOTE: clone each `MANAGED_POINTER' block if keeping a reference
		require
			path_exists: file_path.exists
		local
			maximum_count, file_count, block_count, remainder_count, i: INTEGER
			block: MANAGED_POINTER; file: RAW_FILE
		do
			file_count := byte_count (file_path)

			if max_byte_count.to_boolean then
				maximum_count := max_byte_count.min (file_count)
			else
				maximum_count := file_count
			end

			block_count := maximum_count // block_size
			remainder_count := maximum_count \\ block_size
			create block.make (block_size)
			create file.make_open_read (file_path)
			from i := 1 until i > block_count loop
				file.read_to_managed_pointer (block, 0, block.count)
				action (block)
				i := i + 1
			end
			if remainder_count.to_boolean then
				block.resize (remainder_count)
				file.read_to_managed_pointer (block, 0, remainder_count)
				check
					byte_read_agrees: file.bytes_read = remainder_count
				end
				action (block)
			end
			file.close
		end

	write_text (file_path: FILE_PATH; text: STRING)
		-- write plain text
		do
			write_marked_text (file_path, text, False)
		end

	write_marked_text (file_path: FILE_PATH; text: STRING; utf_bom: BOOLEAN)
		-- write plain text with optional byte order mark
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_write (file_path)
			if utf_bom then
				file.put_string ({UTF_CONVERTER}.Utf_8_bom_to_string_8)
			end
			file.put_string (text)
			file.close
		end

feature -- Contract Support

	valid_what (what: STRING): BOOLEAN
		do
			Result := across what as c all ("rwxs").has (c.item) end
		end

	valid_who (who: STRING): BOOLEAN
		do
			Result := across who as c all ("uog").has (c.item) end
		end

feature {NONE} -- Implementation

	change_permission (path: EL_PATH; who, what: STRING; change: PROCEDURE [FILE, STRING, STRING])
			-- Add/remove permissions to file or directory specified by `path' using `change' action
			-- Add read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		local
			file: FILE; l_who: STRING
		do
			file := info (path, False)
			create l_who.make (1)
			across who as c loop
				l_who.wipe_out
				l_who.append_character (c.item)
				change (file, l_who, what)
			end
		end

	notify_progress (a_file: FILE; final: BOOLEAN)
		do
			if attached {EL_NOTIFYING_FILE} a_file as file then
				if final then
					file.notify_final
				else
					file.notify
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_info_file: EL_INFO_RAW_FILE

end