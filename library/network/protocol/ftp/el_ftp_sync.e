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
	date: "2021-03-23 12:36:19 GMT (Tuesday 23rd March 2021)"
	revision: "21"

class
	EL_FTP_SYNC

inherit
	ANY

	EL_MODULE_LIO

	EL_MODULE_EXCEPTION

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DIRECTORY

	EL_SHARED_PROGRESS_LISTENER

create
	make, make_default

feature {NONE} -- Initialization

	make (sync_file_path: EL_FILE_PATH; a_root_dir: like root_dir)
		do
			make_default
			root_dir := a_root_dir
			sync_table.set_from_file (sync_file_path)
		end

	make_default
			--
		do
			create sync_table.make
			create root_dir
			create file_item_table.make (100)
			create removed_items.make (0)
			create upload_list.make (0)
			create display_uploads
		end

feature -- Access

	removed_items: ARRAYED_LIST [EL_FILE_PATH]

	root_dir: EL_DIR_PATH

	operation_count: INTEGER
		do
			Result := removed_items.count + upload_list.count
		end

	upload_path_list: ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (upload_list.count)
			across upload_list as list loop
				Result.extend (list.item.file_path)
			end
			Result.compare_objects
		end

feature -- Status query

	display_uploads: EL_BOOLEAN_OPTION

	has_changes: BOOLEAN
		do
			Result := not upload_list.is_empty or not removed_items.is_empty
		end

feature -- Element change

	extend (file_item: EL_CRC_32_SYNC_ITEM)
		do
			file_item_table.extend (file_item, file_item.file_path)
		end

	force (file_item: EL_CRC_32_SYNC_ITEM)
		-- `extend' and force `file_item' to be uploaded
		do
			extend (file_item)
			if sync_table.has (file_item.file_path) then
				sync_table [file_item.file_path] := 0
			end
		end

	set_root_dir (a_root_dir: like root_dir)
		do
			root_dir := a_root_dir
		end

	set_sync_table (a_sync_table: like sync_table)
		do
			sync_table := a_sync_table
		end

feature -- Basic operations

	login_and_upload (ftp: EL_FTP_PROTOCOL)
		do
			ftp.open
			if ftp.is_open then
				ftp.login; ftp.change_home_dir
				lio.put_new_line
				progress_listener.display.set_text ("Synchronizing with " + ftp.config.host)
				upload (ftp)
				ftp.close
				sync_table.save
			end
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

	update
		-- update `sync_table' and `removed_items'
		do
			upload_list.grow (file_item_table.count // 2)
			across file_item_table as file loop
				if sync_table.has_key (file.key) then
					if file.item.current_digest /= sync_table.found_item then
						upload_list.extend (file.item)
					end
				else
					upload_list.extend (file.item)
				end
			end
			across sync_table.current_keys as path loop
				if not file_item_table.has_key (path.item) then
					removed_items.extend (path.item)
				end
			end
		end

feature {NONE} -- Implementation

	remove_remote (ftp: EL_FTP_PROTOCOL)
		local
			deleted_dir_set: EL_HASH_SET [EL_DIR_PATH]
			sorted_dir_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [INTEGER, EL_DIR_PATH]
		do
			create deleted_dir_set.make_equal (10)
			across removed_items as path loop
				ftp.delete_file (path.item)
				if ftp.last_succeeded then
					sync_table.remove (path.item)
					progress_listener.notify_tick
					deleted_dir_set.put (path.item.parent)
				end
			end
			-- sort in reverse order of directory step count
			create sorted_dir_list.make_sorted (deleted_dir_set, agent {EL_DIR_PATH}.step_count, False)
			across sorted_dir_list.value_list as dir loop
				if Directory.named (root_dir #+ dir.item).is_empty then
					ftp.remove_directory (dir.item)
				end
			end
		end

	upload (ftp: EL_FTP_PROTOCOL)
		local
			item: EL_FTP_UPLOAD_ITEM
		do
			remove_remote (ftp)
			create item.make_default
			across upload_list as file loop
				item.set_source_path (root_dir + file.item.file_path)
				item.set_destination_dir (file.item.file_path.parent)
				if item.source_path.exists then
					if display_uploads.is_enabled then
						lio.put_path_field ("Uploading", file.item.file_path)
						lio.put_new_line
					end
					ftp.upload (item)
					progress_listener.notify_tick
					if ftp.last_succeeded then
						sync_table [file.item.file_path] := file.item.current_digest -- modified item
					end
				else
					lio.put_path_field ("Missing upload", file.item.file_path)
					lio.put_new_line
				end
			end
		rescue
			sync_table.save
		end

feature {NONE} -- Internal attributes

	file_item_table: HASH_TABLE [EL_CRC_32_SYNC_ITEM, EL_FILE_PATH]

	sync_table: EL_FTP_SYNC_ITEM_TABLE

	upload_list: EL_ARRAYED_LIST [EL_CRC_32_SYNC_ITEM]

end