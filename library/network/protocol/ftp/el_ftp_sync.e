note
	description: "[
		Synchronizes a local directory of files with a corresponding directory on an ftp site
		Files deleted locally are deleted on ftp site as well, and empty directories are deleted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 19:53:12 GMT (Sunday 21st May 2017)"
	revision: "3"

class
	EL_FTP_SYNC

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

	KL_PART_COMPARATOR [EL_DIR_PATH]
		rename
			less_than as has_fewer_steps
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

	EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make (a_ftp: like ftp; a_sync_file_path: like sync_file_path; a_root_dir: like root_dir)
		do
			make_default
			ftp := a_ftp; sync_file_path := a_sync_file_path; root_dir := a_root_dir
		end

	make_default
			--
		do
			create sync_file_path
			create ftp.make_default
			create modified_files.make_equal (20)
			create root_dir
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	ftp: EL_FTP_PROTOCOL

	root_dir: EL_DIR_PATH

	sync_file_path: EL_FILE_PATH

feature -- Element change

	extend_modified (file_path: EL_FILE_PATH)
		require
			is_relative_path: not file_path.is_absolute
			valid_root_dir: not root_dir.is_empty
		do
			modified_files.put (file_path)
		end

	set_root_dir (a_root_dir: like root_dir)
		do
			root_dir := a_root_dir
		end

	set_sync_file_path (a_sync_file_path: like sync_file_path)
		do
			sync_file_path := a_sync_file_path
		end

feature -- Basic operations

	login_and_upload (file_list: LIST [EL_FILE_PATH])
		do
			ftp.open; ftp.login; ftp.change_home_dir
			lio.put_new_line

			progress_listener.display.set_text ("Synchronizing with " + ftp.address.host)
			upload (file_list)
			ftp.close
		end

	upload (file_list: LIST [EL_FILE_PATH])
			-- synchronize files on ftp site
		require
			valid_ftp: ftp.is_open and ftp.is_logged_in
			relative_paths: across file_list as path all not path.item.is_absolute end
		local
			previous_files: like new_previous_files; item: EL_FTP_UPLOAD_ITEM
			deleted_dir_set: EL_HASH_SET [EL_DIR_PATH]
		do
			across modified_files as file_path loop
				progress_listener.increment_estimated_bytes_from_file (root_dir + file_path.item)
			end
			create item.make_default
			previous_files := new_previous_files
			across file_list as file loop
				if previous_files.has (file.item) then
					previous_files.remove (file.item)
				end
				if modified_files.has (file.item) then
					item.set_source_path (root_dir + file.item)
					item.set_destination_path (file.item.parent)
					ftp.upload (item)
				end
			end
			create deleted_dir_set.make_equal (previous_files.count // 10)
			across previous_files as file loop
				ftp.delete_file (file.item)
				deleted_dir_set.put (file.item.parent)
			end
			-- Remove empty directories
			remove_empty_directories (deleted_dir_set)
			write_sync_table (file_list)
			modified_files.wipe_out
		end

feature {NONE} -- Implementation

	has_fewer_steps (u, v: EL_DIR_PATH): BOOLEAN
		do
			Result := u.step_count < v.step_count
		end

	new_previous_files: EL_HASH_SET [EL_FILE_PATH]
		do
			create Result.make_equal (20)
			if sync_file_path.exists then
				across create {EL_FILE_LINE_SOURCE}.make (sync_file_path) as line loop
					Result.put (line.item)
				end
			end
		end

	remove_empty_directories (a_dir_set: EL_HASH_SET [EL_DIR_PATH])
		local
			parent_set, dir_set: EL_HASH_SET [EL_DIR_PATH]; done: BOOLEAN
			parent_dir, dir_path: EL_DIR_PATH
		do
			from dir_set := a_dir_set until done loop
				create parent_set.make (dir_set.count)
				across sorted_dir_list (dir_set) as dir loop
					dir_path := dir.item
					ftp.remove_directory (dir_path)
					parent_dir := dir_path.parent
					if not parent_dir.is_empty then
						parent_set.put (parent_dir)
					end
				end
				if parent_set.is_empty then
					done := True
				else
					dir_set := parent_set
				end
			end
		end

	sorted_dir_list (a_dir_set: EL_HASH_SET [EL_DIR_PATH]): ARRAY [EL_DIR_PATH]
		-- Longer ones first
		local
			quick: DS_ARRAY_QUICK_SORTER [EL_DIR_PATH]
		do
			create quick.make (Current)
			Result := a_dir_set.linear_representation.to_array
			quick.reverse_sort (Result)
		end

	write_sync_table (file_list: LIST [EL_FILE_PATH])
		local
			file: EL_PLAIN_TEXT_FILE
		do
			create file.make_open_write (sync_file_path)
			across file_list as path loop
				if path.cursor_index > 1 then
					file.put_new_line
				end
				file.put_string (path.item)
			end
			file.close
		end

feature {NONE} -- Internal attributes

	modified_files: EL_HASH_SET [EL_FILE_PATH]

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@url", 		agent do ftp.make_write (create {FTP_URL}.make (node.to_string_8)) end],
				["@user-home", agent do ftp.set_home_directory (node.to_string) end],
				["@sync-path", agent do sync_file_path := node.to_expanded_file_path end]
			>>)
		end

end
