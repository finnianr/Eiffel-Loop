note
	description: "OS file system routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 10:31:01 GMT (Saturday 10th July 2021)"
	revision: "35"

deferred class
	EL_FILE_SYSTEM_ROUTINES_I

inherit
	EL_SHARED_DIRECTORY
		rename
			copy as copy_object
		end

	EL_MODULE_CHECKSUM
		rename
			copy as copy_object
		end

	EL_MODULE_ITERABLE
		rename
			copy as copy_object
		end

	EL_MODULE_DIRECTORY
		rename
			copy as copy_object,
			Directory as Stanard_directory
		end

	EL_FILE_OPEN_ROUTINES
		rename
			copy as copy_object
		end

feature {NONE} -- Initialization

	make
		do
			create internal_info_file.make
		end

feature -- Access

	cached (relative_path: EL_FILE_PATH; write_file: PROCEDURE [EL_FILE_PATH]): EL_FILE_PATH
		do
			Result := Stanard_directory.App_cache + relative_path
			if not Result.exists then
				write_file (Result)
			end
		end

	closed_none_plain_text: PLAIN_TEXT_FILE
		do
			create Result.make_with_name ("None.txt")
		end

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		deferred
		end

	file_data (a_file_path: EL_FILE_PATH): MANAGED_POINTER
		require
			file_exists: a_file_path.exists
		do
			if attached open_raw (a_file_path, Read) as l_file then
				create Result.make (l_file.count)
				l_file.read_to_managed_pointer (Result, 0, l_file.count)
				l_file.close
			end
		end

	line_one (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path)
			create Result.make_empty
			if not file.is_empty then
				file.read_line
				Result := file.last_string
			end
			file.close
		end

	parent_set (path_list: ITERABLE [EL_FILE_PATH]; ascending_order: BOOLEAN): EL_ARRAYED_LIST [EL_DIR_PATH]
		-- set of all parent directories of file paths in list `path_list'
		-- if `ascending_order' is `True', results are sorted in ascending order of step count
		-- or else in reverse order
		local
			dir_set: EL_HASH_SET [EL_DIR_PATH]; parent: EL_DIR_PATH
		do
			-- assume average of 20 files per directory
			create dir_set.make ((iterable.count (path_list) // 20).min (10))
			across path_list as path loop
				parent := path.item.parent
				if not parent.is_empty then
					dir_set.put (parent)
				end
			end
			create Result.make_from_array (dir_set.to_array)
			Result.order_by (agent {EL_DIR_PATH}.step_count, ascending_order)
		end

	plain_text (a_file_path: EL_FILE_PATH): STRING
		--
		require
			file_exists: a_file_path.exists
		local
			file: PLAIN_TEXT_FILE; count: INTEGER; line: STRING
			not_first: BOOLEAN
		do
			create file.make_open_read (a_file_path)
			create Result.make (file.count)
			if not file.is_empty then
				from until file.end_of_file loop
					if not_first then
						Result.append_character ('%N')
					else
						not_first := True
					end
					file.read_line
					line := file.last_string
					count := count + line.count + 1
					line.prune_all_trailing ('%R')
					Result.append (line)
				end
			end
			if line.is_empty and not_first then
				Result.remove_tail (1)
			end
			file.close
		end

	plain_text_bomless (a_file_path: EL_FILE_PATH): STRING
		-- file text without byte-order mark
		do
			Result := plain_text (a_file_path)
			if Result.starts_with ({UTF_CONVERTER}.Utf_8_bom_to_string_8) then
				Result.remove_head (3)
			end
		end

	raw_plain_text (a_file_path: EL_FILE_PATH): STRING
		-- plain text preserving carriage return characters '%R'
		require
			file_exists: a_file_path.exists
		local
			file: PLAIN_TEXT_FILE; pointer: MANAGED_POINTER
		do
			create file.make_open_read (a_file_path)
			create Result.make_filled (' ', file.count)
			create pointer.share_from_pointer (Result.area.base_address, Result.count)
			file.read_to_managed_pointer (pointer, 0, Result.count)
			file.close
		end

feature -- File lists

	files (a_dir_path: EL_DIR_PATH; recursively: BOOLEAN): like Directory.files
			--
		do
			if recursively then
				Result := Directory.named (a_dir_path).recursive_files
			else
				Result := Directory.named (a_dir_path).files
			end
		end

	files_with_extension (
		a_dir_path: EL_DIR_PATH; extension: READABLE_STRING_GENERAL; recursively: BOOLEAN
	): like Directory.files
			--
		do
			if recursively then
				Result := Directory.named (a_dir_path).recursive_files_with_extension (extension)
			else
				Result := Directory.named (a_dir_path).files_with_extension (extension)
			end
		end

feature -- Measurement

	file_access_time (file_path: EL_FILE_PATH): INTEGER
		do
			Result := info_file (file_path).access_date
		end

	file_byte_count (a_file_path: EL_FILE_PATH): INTEGER
			--
		do
			Result := info_file (a_file_path).count
		end

	file_checksum (a_file_path: EL_FILE_PATH): NATURAL
		do
			Result := Checksum.file_content (a_file_path)
		end

	file_megabyte_count (a_file_path: EL_FILE_PATH): DOUBLE
			--
		do
			Result := file_byte_count (a_file_path) / 1000000
		end

	file_modification_time (file_path: EL_FILE_PATH): INTEGER
		do
			Result := info_file (file_path).date
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

	make_parents (path_list: ITERABLE [EL_FILE_PATH])
		-- create directory structure to create files in `path_list'
		do
			across parent_set (path_list, True) as set loop
				make_directory (set.item)
			end
		end

	remove_file, remove_directory, remove_path (a_path: EL_PATH)
			--
		require
			exists: a_path.exists
		do
			info_file (a_path).delete
		end

	rename_file (a_file_path, new_file_path: EL_FILE_PATH)
			-- change name of file to new_name. If preserve_extension is true, the original extension is preserved
		require
			file_exists: a_file_path.exists
		do
			info_file (a_file_path).rename_file (new_file_path)
		end

	write_plain_text (a_file_path: EL_FILE_PATH; text: STRING)
			--
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_write (a_file_path)
			file.put_string (text)
			file.close
		end

feature -- Status query

	path_exists (a_path: EL_PATH): BOOLEAN
		do
			Result := info_file (a_path).exists
		end

	directory_exists (a_path: EL_DIR_PATH): BOOLEAN
		do
			Result := info_file (a_path).exists
		end

	file_exists (a_path: EL_FILE_PATH): BOOLEAN
		do
			Result := info_file (a_path).exists
		end

	has_content (a_file_path: EL_FILE_PATH): BOOLEAN
			-- True if file not empty
		do
			if attached open_raw (a_file_path, Read) as l_file then
				Result := not l_file.is_empty
				l_file.close
			end
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
			file := info_file (path)
			create l_who.make (1)
			across who as c loop
				l_who.wipe_out
				l_who.append_character (c.item)
				change (file, l_who, what)
			end
		end

	info_file (a_path: EL_PATH): EL_INFO_RAW_FILE
			--
		do
			Result := internal_info_file
			Result.set_path (a_path)
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

	internal_info_file: EL_INFO_RAW_FILE

end