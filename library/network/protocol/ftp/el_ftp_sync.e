note
	description: "[
		Performs synchronization to an ftp site of set of file items conforming to type [$source EL_FILE_SYNC_ITEM].
		Files deleted locally are deleted on ftp site as well, and empty directories are deleted.
		
		For an example see [$source REPOSITORY_PUBLISHER] which uses the [$source EL_BUILDER_CONTEXT_FTP_SYNC]
		variant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-04 11:14:01 GMT (Thursday 4th October 2018)"
	revision: "8"

class
	EL_FTP_SYNC

inherit
	EL_SHARED_FILE_PROGRESS_LISTENER

	EL_MODULE_LIO

	EL_MODULE_EXCEPTION

	EL_SHARED_DIRECTORY

	EL_MODULE_FILE_SYSTEM

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
			create removed_items.make (0)
			create upload_list.make (0)
		end

feature -- Access

	ftp: EL_FTP_PROTOCOL

	removed_items: ARRAYED_LIST [EL_FILE_PATH]

	root_dir: EL_DIR_PATH

feature -- Status query

	has_changes: BOOLEAN
		do
			Result := not upload_list.is_empty or not removed_items.is_empty
		end

feature -- Element change

	extend (file_item: EL_CRC_32_SYNC_ITEM)
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

	remove_local (local_root_dir: EL_DIR_PATH)
		-- Remove local files
		local
			l_path: EL_FILE_PATH
		do
			across removed_items as path loop
				l_path := local_root_dir + path.item
				if l_path.exists then
					File_system.remove_file (l_path)
				end
			end
		end

	save
		do
			sync_table.save
		end

	update
		-- update `sync_table' and `removed_items'
		do
			upload_list.grow (file_item_table.count // 2)
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
			across sync_table.current_keys as path loop
				if not file_item_table.has_key (path.item) then
					sync_table.remove (path.item)
					removed_items.extend (path.item)
				end
			end
		end

feature {NONE} -- Implementation

	remove_remote
		local
			deleted_dir_set: EL_HASH_SET [EL_DIR_PATH]
			sorted_dir_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [INTEGER, EL_DIR_PATH]
		do
			create deleted_dir_set.make_equal (10)
			across removed_items as path loop
				lio.put_path_field ("Removing", path.item)
				lio.put_new_line
				ftp.delete_file (path.item)
				deleted_dir_set.put (path.item.parent)
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

	upload
		local
			item: EL_FTP_UPLOAD_ITEM
		do
			remove_remote
			across upload_list as file loop
				progress_listener.increment_estimated_bytes_from_file (root_dir + file.item.file_path)
			end
			create item.make_default
			across upload_list as file loop
				item.set_source_path (root_dir + file.item.file_path)
				item.set_destination_path (file.item.file_path.parent)
				if item.source_path.exists then
					ftp.upload (item)
				else
					lio.put_path_field ("Missing upload", file.item.file_path)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	file_item_table: HASH_TABLE [EL_CRC_32_SYNC_ITEM, EL_FILE_PATH]

	sync_table: EL_FTP_SYNC_ITEM_TABLE

	upload_list: EL_ARRAYED_LIST [EL_CRC_32_SYNC_ITEM]

end
