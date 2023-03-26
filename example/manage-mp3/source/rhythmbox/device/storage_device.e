note
	description: "Device to which to mp3 files can be exported"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-26 10:10:06 GMT (Sunday 26th March 2023)"
	revision: "28"

class
	STORAGE_DEVICE

inherit
	M3U_PLAY_LIST_CONSTANTS

	EL_MODULE_CHECKSUM

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_SHARED_OPERATING_ENVIRON

	SONG_QUERY_CONDITIONS

	EXCEPTION_MANAGER

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_task: like task)
		do
			task := a_task
			set_volume (task.volume.to_gvfs)
			create sync_table.make_default
			temporary_dir := Operating_environ.Temp_directory_path #+ generator
			temporary_dir.append_dir_path (task.volume.destination_dir)
			if temporary_dir.exists then
				OS.delete_tree (temporary_dir)
			end
		end

feature -- Access

	volume: EL_GVFS_VOLUME

feature -- Status query

	is_windows_format: BOOLEAN
			-- true if volume formatted as FAT32 or NTFS
		do
			Result := task.volume.is_windows_format
		end

feature -- Element change

	set_volume (a_volume: like volume)
		do
			volume := a_volume
			if volume.is_valid then
				volume.extend_uri_root (task.volume.destination_dir)
			end
		end

feature -- Basic operations

	export_songs_and_playlists (a_condition: EL_QUERY_CONDITION [RBOX_SONG])
		local
			songs_to_export: like Database.songs.query; old_sync_table: like sync_table
			items_to_export: EL_QUERYABLE_ARRAYED_LIST [MEDIA_ITEM]
			items_to_copy, items_to_update: EL_ARRAYED_LIST [MEDIA_ITEM]
		do
			File_system.make_directory (temporary_dir)
			read_sync_table
			songs_to_export := Database.existing_songs_query (a_condition)

			create items_to_export.make (songs_to_export.count + playlists.count)
			items_to_export.append (songs_to_export)
			items_to_export.append (playlists)

			items_to_copy := items_to_export.query (sync_table.exported_item_is_new)
			items_to_update := items_to_export.query (sync_table.exported_item_is_updated)
			items_to_update.do_all (agent {MEDIA_ITEM}.mark_as_update)

			if attached {like song_in_some_playlist} a_condition then
				-- If we are only exporting playlist songs we don't want to delete everything else on device
				across items_to_copy.joined (items_to_update) as media loop
					sync_table [media.item.id] := media.item.to_sync_item (is_windows_format)
				end
				sync_table.deletion_list (sync_table, items_to_update).do_all (agent delete_file)
			else
				old_sync_table := sync_table; sync_table := new_sync_table (items_to_export)
				old_sync_table.deletion_list (sync_table, items_to_update).do_all (agent delete_file)
			end
			export_media_items (joined (items_to_copy, items_to_update))
			lio.put_new_line

			store_sync_table
			if has_sync_table_changed and then task.is_full_export_task then
				Database.store_in_directory (temporary_dir)
			end
			export_temporary_dir
			File_system.delete_empty_branch (temporary_dir)
		end

	delete_sync_table_file
		do
			if local_sync_table_file_path.exists then
				File_system.remove_file (local_sync_table_file_path)
			end
		end

feature {NONE} -- Factory

	new_m3u_playlist (playlist: RBOX_PLAYLIST; output_path: FILE_PATH): M3U_PLAYLIST
		do
			create Result.make (playlist, is_windows_format, output_path)
		end

	new_sync_table (media_item_list: EL_ARRAYED_LIST [MEDIA_ITEM]): like sync_table
		do
			create Result.make_default
			Result.set_output_path (sync_table.output_path)
			Result.accommodate (media_item_list.count)
			across media_item_list as media loop
				Result [media.item.id] := media.item.to_sync_item (is_windows_format)
			end
		end

feature {NONE} -- Volume file operations

	 read_sync_table
	 	local
	 		backup_table_path: FILE_PATH; local_sync_table_dir: DIR_PATH
	 	do
			lio.put_line ("Reading file sync info")
			if local_sync_table_file_path.exists then
				backup_table_path := local_sync_table_file_path.with_new_extension ("bak")
				if backup_table_path.exists then
					File_system.remove_file (backup_table_path)
				end
				File_system.rename_file (local_sync_table_file_path, backup_table_path)
			end
	 		if volume.file_exists (Sync_table_name) then
	 			local_sync_table_dir := local_sync_table_file_path.parent
				File_system.make_directory (local_sync_table_dir)
		 		volume.copy_file_from (Sync_table_name, local_sync_table_dir)
	 		end
			create sync_table.make_from_file (local_sync_table_file_path)
			last_sync_checksum := sync_checksum
		rescue
			recover_from_error; retry
	 	end

	delete_file (file_path: FILE_PATH)
			-- delete file on volume
	 	do
			lio.put_path_field ("Deleting %S", file_path)
			lio.put_new_line
			volume.remove_file (file_path)
		rescue
			recover_from_error; retry
		end

	move_file_to_volume (file_path: FILE_PATH; volume_dir: DIR_PATH)
		do
			copy_file_to_volume (file_path, volume_dir)
			File_system.remove_file (file_path)
		end

	copy_file_to_volume (file_path: FILE_PATH; volume_dir: DIR_PATH)
	 	do
			volume.make_directory (volume_dir)
			volume.copy_file_to (file_path, volume_dir)
		rescue
			recover_from_error ; retry
		end

	recover_from_error
		local
			volume_is_valid: BOOLEAN; message: READABLE_STRING_GENERAL
		do
			message := last_exception.description
			from until volume_is_valid loop
				lio.put_line (message)
				if User_input.approved_action_y_n ("Retry?") then
					-- User reconnect device if disconnected
					-- Might have different usb port number in url
					volume.reset_uri_root
					if volume.is_valid then
						volume.extend_uri_root (task.volume.destination_dir)
						volume_is_valid := True
					else
						message := "Volume not mounted"
					end
				end
			end
		end

feature {NONE} -- Implementation

	adjust_genre (id3_info: TL_MPEG_FILE)
		do
		end

	export_item (media_item: MEDIA_ITEM)
		local
			temp_file_path, relative_file_path: FILE_PATH
			id3_info: TL_MPEG_FILE; m3u_playlist: like new_m3u_playlist
		do
			relative_file_path := media_item.exported_relative_path (is_windows_format)
			temp_file_path := temporary_dir + relative_file_path.base

			if not media_item.is_update implies not volume.file_exists (relative_file_path) then
				if attached {RBOX_SONG} media_item as song then
					OS.copy_file (song.mp3_path, temp_file_path)

					create id3_info.make (temp_file_path)
					adjust_genre (id3_info)
					id3_info.save_version (task.volume.major_version)
					id3_info.dispose

				elseif attached {RBOX_PLAYLIST} media_item as playlist then
					m3u_playlist := new_m3u_playlist (playlist, temp_file_path)
					m3u_playlist.serialize
				end
				move_file_to_volume (temp_file_path, relative_file_path.parent)
			end
		end

	export_media_items (list: ARRAYED_LIST [MEDIA_ITEM])
		local
			progress_info: EL_QUANTITY_PROGRESS_INFO; exported_mb: DOUBLE
		do
			if list.is_empty then
				lio.put_line ("Nothing to export")
			else
				across list as media loop
					 exported_mb := exported_mb + media.item.file_size_mb
				end
				create progress_info.make (exported_mb, 1, "mb")
--				if log.current_routine_is_active then
--					progress_info.enable_line_advance
--				end
				across list as media loop
					progress_info.increment (media.item.file_size_mb)
					lio.put_string (progress_info.last_string)
					lio.put_path_field (" Copying %S", media.item.relative_path)
					lio.put_new_line

					export_item (media.item)
				end
			end
		end

	export_temporary_dir
		do
			across OS.file_list (temporary_dir, "*") as file_path loop
				lio.put_path_field ("Moving %S", file_path.item)
				lio.put_new_line
				move_file_to_volume (file_path.item, Empty_dir)
			end
		end

	joined (list_a, list_b: ARRAYED_LIST [MEDIA_ITEM]): ARRAYED_LIST [MEDIA_ITEM]
		do
			create Result.make (list_a.count + list_b.count)
			Result.append (list_a); Result.append (list_b)
		end

	playlist_subdirectory_name: ZSTRING
		do
			Result := task.playlist_export.subdirectory_name
		end

	playlists: EL_ARRAYED_LIST [RBOX_PLAYLIST]
		do
			Result := Database.playlists
		end

	store_sync_table
	 	do
			lio.put_line ("Saving file sync info")
			has_sync_table_changed := False
			sync_table.store
			if last_sync_checksum = sync_checksum then
				lio.put_line ("Sync file has not changed")
			else
				copy_file_to_volume (sync_table.output_path, Empty_dir)
				has_sync_table_changed := True
			end
	 	end

	songs_by_audio_id: like Database.songs_by_audio_id
		do
			Result := Database.songs_by_audio_id
		end

	sync_checksum: NATURAL
		do
			Result := Checksum.file_content (sync_table.output_path)
		end

	local_sync_table_file_path: FILE_PATH
		do
			Result := Directory.app_cache.joined_file_tuple ([Device_data, task.volume.name, Sync_table_name])
		end

feature {NONE} -- Internal attributes

	task: EXPORT_TO_DEVICE_TASK

	has_sync_table_changed: BOOLEAN

	last_sync_checksum: NATURAL

	sync_table: MEDIA_ITEM_DEVICE_SYNC_TABLE

	temporary_dir: DIR_PATH

feature {NONE} -- Constants

	Device_data: ZSTRING
		once
			Result := "device-data"
		end

	Empty_dir: DIR_PATH
		once
			create Result
		end

end