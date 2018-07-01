note
	description: "[
		Synchronizes a local directory of files with a corresponding directory on an ftp site
		Files deleted locally are deleted on ftp site as well, and empty directories are deleted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-17 14:41:20 GMT (Saturday 17th February 2018)"
	revision: "4"

class
	EL_FTP_SYNC

inherit
	EL_SHARED_FILE_PROGRESS_LISTENER

	EL_MODULE_LIO

	EL_MODULE_EXCEPTION

	EL_SHARED_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make (a_ftp: like ftp; sync_file_path: EL_FILE_PATH; a_root_dir: like root_dir)
		do
			make_default
			ftp := a_ftp; root_dir := a_root_dir
			sync_table.set_from_file (sync_file_path)
		end

	make_default
			--
		do
			create sync_table.make
			create ftp.make_default
			create root_dir
			create file_item_table.make (100)
		end

feature -- Access

	ftp: EL_FTP_PROTOCOL

	root_dir: EL_DIR_PATH

feature -- Element change

	extend (file_item: EL_FILE_SYNC_ITEM)
		do
			file_item_table.extend (file_item, file_item.file_path)
		end

	set_root_dir (a_root_dir: like root_dir)
		do
			root_dir := a_root_dir
		end

feature -- Basic operations

	login_and_upload
		do
			ftp.open; ftp.login; ftp.change_home_dir
			lio.put_new_line

			progress_listener.display.set_text ("Synchronizing with " + ftp.address.host)
			upload
			ftp.close
		end

	upload
		local
			upload_list: EL_ARRAYED_LIST [EL_FILE_SYNC_ITEM]
			item: EL_FTP_UPLOAD_ITEM
		do
			if not sync_table.is_empty then
				delete_removed_files
			end
			create upload_list.make (file_item_table.count // 2)
			across file_item_table as file loop
				if sync_table.has_key (file.key) then
					if file.item.current_digest /= sync_table.found_item then
						upload_list.extend (file.item)
						sync_table [file.key] := file.item.current_digest -- modified item
					end
				else
					upload_list.extend (file.item)
					sync_table.extend (file.item.current_digest, file.key) -- new item
				end
			end
			across upload_list as file loop
				progress_listener.increment_estimated_bytes_from_file (root_dir + file.item.file_path)
			end
			create item.make_default
			across upload_list as file loop
				item.set_source_path (root_dir + file.item.file_path)
				item.set_destination_path (file.item.file_path.parent)
				ftp.upload (item)
			end
			sync_table.save
		end

feature {NONE} -- Implementation

	delete_removed_files
		local
			deleted_dir_set: EL_HASH_SET [EL_DIR_PATH]
			sorted_dir_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [INTEGER, EL_DIR_PATH]
		do
			create deleted_dir_set.make_equal (10)
			across sync_table.current_keys as path loop
				if not file_item_table.has (path.item) then
					lio.put_path_field ("Removing file", path.item)
					lio.put_new_line
					sync_table.remove (path.item)
					ftp.delete_file (path.item)
					deleted_dir_set.put (path.item.parent)
				end
			end
			-- sort in reverse order of directory step count
			create sorted_dir_list.make_sorted (deleted_dir_set, agent {EL_DIR_PATH}.step_count, False)
			across sorted_dir_list.value_list as dir loop
				if named_directory (root_dir.joined_dir_path (dir.item)).is_empty then
					ftp.remove_directory (dir.item)
				end
			end
			if not deleted_dir_set.is_empty then
				sync_table.save
			end
		end

feature {NONE} -- Internal attributes

	file_item_table: HASH_TABLE [EL_FILE_SYNC_ITEM, EL_FILE_PATH]

	sync_table: EL_FTP_SYNC_ITEM_TABLE

end
