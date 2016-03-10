note
	description: "Device to which to mp3 files can be exported"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-18 10:44:17 GMT (Wednesday 18th December 2013)"
	revision: "2"

class
	USB_DEVICE

inherit
	RHYTHMBOX_CONSTANTS

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_SHARED_ENVIRONMENTS

	SONG_QUERY_CONDITIONS

create
	make

feature {NONE} -- Initialization

	make (a_export_config: like export_config; a_database: like database)
		do
			log.enter_with_args ("make", << a_export_config.volume.name, a_export_config.volume.destination_dir >>)
			export_config := a_export_config; database := a_database
			set_volume (export_config.new_volume)
			create sync_info.make_default
			temporary_dir := Operating.Temp_directory_path.joined_dir_path (generator)
			temporary_dir.append_dir_path (export_config.volume.destination_dir)
			if temporary_dir.exists then
				File_system.delete_tree (temporary_dir)
			end
			log.exit
		end

feature -- Access

	volume: EL_GVFS_VOLUME

feature -- Element change

	set_volume (a_volume: like volume)
		do
			volume := a_volume
			volume.make_directory (export_config.volume.destination_dir)
			volume.uri_root.append_dir_path (export_config.volume.destination_dir)
		end

feature -- Basic operations

	export_songs_and_playlists (a_condition: EL_QUERY_CONDITION [RBOX_SONG])
		local
			songs_to_copy, songs_to_update: ARRAYED_LIST [RBOX_SONG]
			songs_to_export: like songs.query
			m3u_wildcard: ASTRING; old_sync_info: like sync_info
			is_playlist_export: BOOLEAN
		do
			log.enter ("export_songs")
			is_playlist_export := attached {PLAYLIST_MEMBER_QUERY_CONDITION} a_condition
			copy_temporary_files
			songs_to_export := songs.query (not song_is_hidden and a_condition)

			songs_to_copy := songs_to_export.query (song_is_new_export (sync_info))
			songs_to_update := songs_to_export.query (song_is_updated_export (sync_info))

			if is_playlist_export then
				-- If we are only exporting playlist songs we don't want to delete everything else on device
				across songs_to_copy as song loop
					sync_info [song.item.track_id] := song.item
				end
				delete_files (sync_info.deletion_list (sync_info, songs_to_update))
			else
				old_sync_info := sync_info; sync_info := new_sync_info (songs_to_export)
				delete_files (old_sync_info.deletion_list (sync_info, songs_to_update))
			end
			across << songs_to_copy, songs_to_update >> as song_list loop
				copy_songs (song_list.item)
			end
			log.put_new_line

			log.put_line ("Writing playlists")
			m3u_wildcard := "*."
			m3u_wildcard.append (export_config.playlist_export.m3u_extension)
			volume.delete_directory_files (playlist_subdirectory_name, m3u_wildcard)
			playlists.do_all (agent write_m3u_playlist)

			log.put_line ("Saving sync info")
			sync_info.store
			if export_config.is_full_export_task then
				database.store_in_directory (temporary_dir)
			end
			move_files_to_volume
			log.exit
		end

feature {NONE} -- Factory

	new_m3u_playlist (playlist: RBOX_PLAYLIST; output_path: EL_FILE_PATH): M3U_PLAYLIST
		do
			create Result.make (playlist.m3u_list, playlist_root, output_path)
		end

	new_sync_info (song_list: EL_ARRAYED_LIST [RBOX_SONG]): like sync_info
		do
			create Result.make_default
			Result.set_output_path (sync_info.output_path)
			Result.accommodate (song_list.count)
			across song_list as song loop
				Result [song.item.track_id] := song.item
			end
		end

feature {NONE} -- Implementation

	 copy_temporary_files
	 	do
			File_system.make_directory (temporary_dir)
			File_system.make_directory (temporary_playlist_dir)

	 		if volume.file_exists (Sync_info_name) then
		 		volume.copy_file_from (Sync_info_name, temporary_dir)
	 		end
			create sync_info.make_from_file (temporary_dir + Sync_info_name)
	 	end

	adjust_genre (id3_info: EL_ID3_INFO)
		do
		end

	copy_songs (song_list: ARRAYED_LIST [RBOX_SONG])
		local
			progress_info: EL_QUANTITY_PROGRESS_INFO; megabytes: DOUBLE
		do
			across song_list as song loop
				 megabytes := megabytes + File_system.file_megabyte_count (song.item.mp3_path)
			end
			create progress_info.make (megabytes, 1, "mb")
			if log.current_routine_is_active then
				progress_info.enable_line_advance
			end
			across song_list as song loop
				progress_info.increment (File_system.file_megabyte_count (song.item.mp3_path))
				log_or_io.put_string (progress_info.last_string)
				log_or_io.put_path_field (" Copying", song.item.mp3_relative_path)
				log_or_io.put_new_line

				export_song (song.item)
			end
		end

	delete_files (list: ARRAYED_LIST [EL_FILE_PATH])
		do
			across list as path loop
				log_or_io.put_path_field ("Deleting", path.item)
				log_or_io.put_new_line
				volume.delete_file (path.item)
			end
		end

	export_song (song: like songs.item)
		local
			destination_file_path, temp_file_path: EL_FILE_PATH
			id3_info: EL_ID3_INFO
		do
			destination_file_path := song.mp3_relative_ntfs_path

			temp_file_path := temporary_dir + destination_file_path.base
			File_system.copy (song.mp3_path, temp_file_path)

			create id3_info.make (temp_file_path)
			id3_info.set_encoding ("UTF-8")

			adjust_genre (id3_info)
			id3_info.set_version (export_config.volume.id3_version)
			id3_info.update

			move_file_to_volume (temp_file_path, destination_file_path.parent)
		end

	move_file_to_volume (file_path: EL_FILE_PATH; volume_dir: EL_DIR_PATH)
		local
			copied: BOOLEAN
		do
			volume.make_directory (volume_dir)
			from until copied loop
				volume.copy_file_to (file_path, volume_dir)
				if volume.has_error then
					log_or_io.put_string ("Retry (y/n)?")
					if not User_input.entered_letter ('y') then
						copied := True
					end
				else
					copied := True
				end
			end
			File_system.remove_file (file_path)
		end

	move_files_to_volume
		do
			across File_system.file_list (temporary_dir, "*") as file_path loop
				log_or_io.put_labeled_string ("Moving file", file_path.item.base)
				log_or_io.put_new_line
				move_file_to_volume (file_path.item, file_path.item.relative_path (temporary_dir).parent)
			end
			File_system.delete_tree (temporary_playlist_dir)
			File_system.delete_empty_branch (temporary_dir)
		end

	playlist_root: ASTRING
		do
			Result := export_config.playlist_export.root
		end

	playlist_subdirectory_name: ASTRING
		do
			Result := export_config.playlist_export.subdirectory_name
		end

	playlists: like database.playlists
		do
			Result := database.playlists
		end

	songs: like database.songs
		do
			Result := database.songs
		end

	songs_by_track_id: like database.songs_by_track_id
		do
			Result := database.songs_by_track_id
		end

	temporary_playlist_dir: EL_DIR_PATH
		do
			Result := temporary_dir.joined_dir_path (playlist_subdirectory_name)
		end

	write_m3u_playlist (playlist: RBOX_PLAYLIST)
			--
		local
			m3u_playlist: like new_m3u_playlist
			file_path: EL_FILE_PATH
		do
			file_path := temporary_playlist_dir + playlist.name
			file_path.add_extension (export_config.playlist_export.m3u_extension)
			m3u_playlist := new_m3u_playlist (playlist, file_path)
			m3u_playlist.serialize
		end

feature {NONE} -- Internal attributes

	database: RBOX_DATABASE

	export_config: MANAGER_CONFIG

	sync_info: DEVICE_SYNC_INFO_TABLE

	temporary_dir: EL_DIR_PATH

feature {NONE} -- Constants

	ID3: EL_ID3_ENCODINGS
		once
			create Result
		end

end
