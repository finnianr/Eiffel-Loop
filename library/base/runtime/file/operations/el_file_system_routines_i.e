note
	description: "OS file system routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-26 10:38:09 GMT (Tuesday 26th November 2019)"
	revision: "17"

deferred class
	EL_FILE_SYSTEM_ROUTINES_I

inherit
	EL_SHARED_DIRECTORY
		rename
			copy as copy_object
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		rename
			copy as copy_object
		end

feature -- Access

	closed_none_plain_text: PLAIN_TEXT_FILE
		do
			create Result.make_with_name ("None.txt")
		end

	escaped_path (path: EL_PATH): ZSTRING
		deferred
		end

	file_data (a_file_path: EL_FILE_PATH): MANAGED_POINTER
		require
			file_exists: a_file_path.exists
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path)
			create Result.make (l_file.count)
			l_file.read_to_managed_pointer (Result, 0, l_file.count)
			l_file.close
		end

	line_one (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			text_file: PLAIN_TEXT_FILE
		do
			create text_file.make_open_read (a_file_path)
			create Result.make_empty
			if not text_file.is_empty then
				text_file.read_line
				Result := text_file.last_string
			end
			text_file.close
		end

	plain_text (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			text_file: PLAIN_TEXT_FILE; count: INTEGER; line: STRING
		do
			create text_file.make_open_read (a_file_path)
			create Result.make (text_file.count)
			if not text_file.is_empty then
				from until text_file.end_of_file loop
					text_file.read_line
					line := text_file.last_string
					count := count + line.count + 1
					line.prune_all_trailing ('%R')
					Result.append (line)
					if count < text_file.count then
						Result.append_character ('%N')
					end
				end
			end
			text_file.close
		end

	plain_text_bomless (a_file_path: EL_FILE_PATH): STRING
		-- file text without byte-order mark
		do
			Result := plain_text (a_file_path)
			if Result.starts_with ({UTF_CONVERTER}.Utf_8_bom_to_string_8) then
				Result.remove_head (3)
			end
		end

feature -- File lists

	files (a_dir_path: EL_DIR_PATH): like Directory.files
			--
		do
			Result := Directory.named (a_dir_path).recursive_files
		end

	files_with_extension (a_dir_path: EL_DIR_PATH; extension: READABLE_STRING_GENERAL): like Directory.files
			--
		do
			Result := Directory.named (a_dir_path).files_with_extension (extension)
		end

	recursive_files (a_dir_path: EL_DIR_PATH): like Directory.recursive_files
			--
		do
			Result := Directory.named (a_dir_path).recursive_files
		end

	recursive_files_with_extension (a_dir_path: EL_DIR_PATH; extension: READABLE_STRING_GENERAL): like Directory.recursive_files
			--
		do
			Result := Directory.named (a_dir_path).recursive_files_with_extension (extension)
		end

feature -- Measurement

	file_access_time (file_path: EL_FILE_PATH): INTEGER
		do
			Result := closed_raw_file (file_path).access_date
		end

	file_byte_count (a_file_path: EL_FILE_PATH): INTEGER
			--
		do
			Result := closed_raw_file (a_file_path).count
		end

	file_checksum (a_file_path: EL_FILE_PATH): NATURAL
		local
			crc: like crc_generator
		do
			crc := crc_generator
			crc.add_file (a_file_path)
			Result := crc.checksum
		end

	file_megabyte_count (a_file_path: EL_FILE_PATH): DOUBLE
			--
		do
			Result := file_byte_count (a_file_path) / 1000000
		end

	file_modification_time (file_path: EL_FILE_PATH): INTEGER
		do
			Result := closed_raw_file (file_path).date
		end

feature -- File property change

	add_permission (path: EL_FILE_PATH; who, what: STRING)
			-- Add read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		require
			file_exists: path.exists
			valid_who: valid_who (who)
			valid_what: valid_what (what)
		do
			change_permission (path, who, what, agent {FILE}.add_permission)
		end

	remove_permission (path: EL_FILE_PATH; who, what: STRING)
			-- remove read, write, execute or setuid permission
			-- for `who' ('u', 'g' or 'o') to `what'.
		require
			file_exists: path.exists
			valid_who: valid_who (who)
			valid_what: valid_what (what)
		do
			change_permission (path, who, what, agent {FILE}.remove_permission)
		end

	set_file_modification_time (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		deferred
		ensure
			modification_time_set: file_modification_time (file_path) = date_time
		end

	set_file_stamp (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		deferred
		ensure
			file_access_time_set: file_access_time (file_path) = date_time
			modification_time_set: file_modification_time (file_path) = date_time
		end

feature -- Basic operations

	copy_file_contents (source_file: FILE; destination_path: EL_FILE_PATH)
		require
			exists_and_closed: source_file.is_closed and source_file.exists
		local
			destination_file: FILE; data: MANAGED_POINTER
			byte_count: INTEGER
		do
			make_directory (destination_path.parent)
			destination_file := source_file.twin
			source_file.open_read
			byte_count := source_file.count
			-- Read
			create data.make (byte_count)
			source_file.read_to_managed_pointer (data, 0, byte_count)
			notify_progress (source_file, False)
			source_file.close
			-- Write
			destination_file.make_open_write (destination_path)
			destination_file.put_managed_pointer (data, 0, byte_count)
			notify_progress (destination_file, True)
			destination_file.close
		end

	copy_file_contents_to_dir (source_file: FILE; destination_dir: EL_DIR_PATH)
		local
			destination_path: EL_FILE_PATH
		do
			destination_path := source_file.path
			destination_path.set_parent_path (destination_dir)
			copy_file_contents (source_file, destination_path)
		end

	delete_empty_branch (dir_path: EL_DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir_steps: EL_PATH_STEPS
			dir: like Directory.named
		do
			dir_steps := dir_path
			from dir := Directory.named (dir_path) until dir_steps.is_empty or else not dir.is_empty loop
				dir.delete
				dir_steps.remove_tail (1)
				dir.make_with_name (dir_steps.to_string_32)
			end
		end

	delete_if_empty (dir_path: EL_DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir: like Directory.named
		do
			dir := Directory.named (dir_path)
			if dir.is_empty then
				dir.delete
			end
		end

	make_directory (a_dir_path: EL_DIR_PATH)
			-- recursively create directory
		local
			dir_parent: EL_DIR_PATH
		do
			if not (a_dir_path.is_empty or else a_dir_path.exists) then
				dir_parent := a_dir_path.parent
				make_directory (dir_parent)
				if dir_parent.exists_and_is_writeable then
					Directory.named (a_dir_path).create_dir
				end
			end
		end

	remove_file (a_file_path: EL_FILE_PATH)
			--
		require
			file_exists: a_file_path.exists
		do
			closed_raw_file (a_file_path).delete
		end

	rename_file (a_file_path, new_file_path: EL_FILE_PATH)
			-- change name of file to new_name. If preserve_extension is true, the original extension is preserved
		require
			file_exists: a_file_path.exists
		do
			closed_raw_file (a_file_path).rename_file (new_file_path)
		end

	write_plain_text (a_file_path: EL_FILE_PATH; text: STRING)
			--
		local
			text_file: PLAIN_TEXT_FILE
		do
			create text_file.make_open_write (a_file_path)
			text_file.put_string (text)
			text_file.close
		end

feature -- Status query

	file_exists (a_file_path: EL_FILE_PATH): BOOLEAN
		do
			Result := closed_raw_file (a_file_path).exists
		end

	has_content (a_file_path: EL_FILE_PATH): BOOLEAN
			-- True if file not empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path)
			Result := not l_file.is_empty
			l_file.close
		end

	is_file_newer (path_1, path_2: EL_FILE_PATH): BOOLEAN
		-- `True' if either A or B is true
		-- A. `path_1' modification time is greater than `path_2' modification time
		-- B. `path_2' does not exist
		require
			path_1_exists: path_1.exists
		do
			Result := not path_2.exists or else file_modification_time (path_1) > file_modification_time (path_2)
		end

	is_writeable_directory (dir_path: EL_DIR_PATH): BOOLEAN
		do
			Result := Directory.named (dir_path).is_writable
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
			file := closed_raw_file (path)
			create l_who.make (1)
			across who as c loop
				l_who.wipe_out
				l_who.append_character (c.item)
				change (file, l_who, what)
			end
		end

	closed_raw_file (a_path: EL_PATH): RAW_FILE
			--
		do
			if attached {RAW_FILE} internal_raw_file as raw_file then
				raw_file.make_with_name (a_path.as_string_32)
				Result := raw_file
			else
				create Result.make_with_name (a_path.as_string_32)
				internal_raw_file := Result
			end
		end

	notify_progress (file: FILE; final: BOOLEAN)
		do
			if attached {EL_NOTIFYING_FILE} file as l_file then
				if final then
					l_file.notify_final
				else
					l_file.notify
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_raw_file: detachable RAW_FILE

end
