note
	description: "Summary description for {RHYTHMBOX_MUSIC_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 7:47:42 GMT (Thursday 23rd June 2016)"
	revision: "4"

class
	RHYTHMBOX_MUSIC_MANAGER

inherit
	EL_COMMAND

	EL_MODULE_AUDIO_COMMAND

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_TIME

	SONG_QUERY_CONDITIONS

	TASK_CONSTANTS


create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			File_system.make_directory (config.dj_events.playlist_dir)
			create file_path; create dir_path; create last_album_name.make_empty
		end

feature -- Basic operations

	execute
			--
		local
			tasks: like task_table
		do
			log.enter ("run")
			from until user_quit loop
				tasks := task_table
				tasks.search (config.task.to_string_8)
				if tasks.found then
					log_or_io.put_labeled_string ("Task", config.task)
					log_or_io.put_new_line
					if is_rhythmbox_open then
						log_or_io.put_line ("ERROR: Rhythmbox application is open. Exit and try again.")
					else
						config.error_check
						if config.error_message.is_empty then
							tasks.found_item.apply
						else
							log_or_io.put_labeled_string ("ERROR", config.error_message)
						end
					end
				else
					log_or_io.put_line ("ERROR")
					log_or_io.put_labeled_string ("Task not found", config.task)
					log_or_io.put_new_line
				end
				ask_user_for_task
			end
			log.exit
		end

feature -- Status query

	is_rhythmbox_open: BOOLEAN
		local
			rhythmbox: DETECT_RHYTHMBOX_COMMAND
		do
			create rhythmbox.make
			rhythmbox.execute
			Result := rhythmbox.is_launched
		end

	user_quit: BOOLEAN

feature -- Tasks

	collate_songs
		-- sort mp3 files into directories according to genre and artist set in Rhythmbox music library database.
		-- Playlist locations will be updated to match new locations.
		local
			new_mp3_path: EL_FILE_PATH; song: RBOX_SONG
		do
			log.enter ("collate_songs")
			Database.songs.do_query (not one_of (<< song_is_hidden, song_is_cortina, song_has_normalized_mp3_path >>))
			if Database.songs.last_query_items.is_empty then
				log_or_io.put_line ("All songs are normalized")
			else
				across Database.songs.last_query_items as query loop
					song := query.item
					new_mp3_path := song.unique_normalized_mp3_path
					log_or_io.put_labeled_string ("Old path", song.mp3_relative_path)
					log_or_io.put_new_line
					log_or_io.put_labeled_string ("New path", new_mp3_path.relative_path (Database.mp3_root_location))
					log_or_io.put_new_line
					log_or_io.put_new_line
					File_system.make_directory (new_mp3_path.parent)
					File_system.move_file (song.mp3_path, new_mp3_path)
					if song.mp3_path.parent.exists then
						File_system.delete_empty_branch (song.mp3_path.parent)
					end
					Database.songs_by_location.replace_key (new_mp3_path, song.mp3_path)
					song.set_mp3_path (new_mp3_path)
				end
				Database.store_all
				File_system.make_directory (Database.mp3_root_location.joined_dir_path ("Additions"))
			end
			log.exit
		end

	display_music_brainz_info
		local
			id3_info: EL_ID3_INFO
		do
			log.enter ("display_music_brainz_info")
			across Database.songs.query (not song_has_audio_id) as song loop
				log_or_io.put_path_field ("MP3", song.item.mp3_path)
				log_or_io.put_new_line
				create id3_info.make (song.item.mp3_path)
				across id3_info.user_text_table as user_text loop
					log_or_io.put_string_field (user_text.key, user_text.item.string)
					log_or_io.put_new_line
				end
				log_or_io.put_line ("UNIQUE IDs")
				across id3_info.unique_id_list as unique_id loop
					log_or_io.put_string_field (unique_id.item.owner, unique_id.item.id)
					log_or_io.put_new_line
				end
				log_or_io.put_new_line
			end
			log.exit
		end

	publish_dj_events
		local
			events_publisher: DJ_EVENTS_PUBLISHER
		do
			log.enter ("publish_dj_events")
			Database.set_exported_playlists (config.dj_events.playlist_dir)
			create events_publisher.make (config.dj_events.publisher, Database.playlists_exported)
			events_publisher.publish
			log.exit
		end

	relocate_songs
			-- relocate song in Music Extra playlist
		local
			silence_1_sec: RBOX_SONG
		do
			silence_1_sec := Database.silence_intervals [1]
			if Database.music_extra_playlist.count = 1 then
				log_or_io.put_line ("No songs listed in %"Music Extra%" (except %"Silence 1 sec%")")
			else
				across Database.music_extra_playlist as song loop
					log_or_io.put_labeled_string ("Song", song.item.mp3_relative_path)
					if song.item = silence_1_sec then
						log_or_io.put_line (" is silence")
					elseif Database.is_song_in_any_playlist (song.item) then
						log_or_io.put_line (" belongs to a playlist")
					else
						Database.remove (song.item)
						song.item.set_mp3_root_location (config.extra_music_dir)
						song.item.move_mp3_to_normalized_file_path
						log_or_io.put_line (" relocated to Music Extra")
					end
				end
				Database.music_extra_playlist.wipe_out
				Database.music_extra_playlist.extend (silence_1_sec)
				database.store_all
			end
		end

	replace_cortina_set
		local
			cortina_set: CORTINA_SET
		do
			log.enter ("replace_cortina_set")
			ask_user_for_file_path ("mp3 for cortina")

			if Database.songs_by_location.has (file_path) then
				log_or_io.put_line ("Replacing current set")
				create cortina_set.make (Database, config, Database.songs_by_location [file_path])
				Database.replace_cortinas (cortina_set)
				Database.store_all
			else
				log_or_io.put_path_field ("ERROR file not found", file_path)
				log_or_io.put_new_line
			end
			log.exit
		end

	replace_songs
		local
			substitution_list: like new_substitution_list
		do
			log.enter ("replace_songs")
			substitution_list := new_substitution_list
			across substitution_list as substitution loop
				if substitution.item.deleted_path /~ substitution.item.replacement_path
					and then across << substitution.item.deleted_path, substitution.item.replacement_path >> as path all
						Database.songs_by_location.has (path.item)
					end
				then
					Database.replace (substitution.item.deleted_path, substitution.item.replacement_path)
					Database.remove (Database.songs_by_location [substitution.item.deleted_path])
					File_system.delete_file (substitution.item.deleted_path)
				else
					log_or_io.put_line ("INVALID SUBSTITUTION")
					log_or_io.put_path_field ("Target", substitution.item.deleted_path)
					log_or_io.put_new_line
					log_or_io.put_path_field ("Replacement", substitution.item.replacement_path)
					log_or_io.put_new_line
				end
			end
			if not substitution_list.is_empty then
				Database.store_all
			end
			log.exit
		end

feature -- Tasks: Import/Export

	export_dj_events
		local
			events_file_path: EL_FILE_PATH
			event_playlist: DJ_EVENT_PLAYLIST
		do
			log.enter ("export_dj_events")
			across Database.playlists as playlist loop
				events_file_path := config.dj_events.playlist_dir + playlist.item.name
				events_file_path.add_extension ("pyx")
				if not events_file_path.exists then
					create event_playlist.make (Database, playlist.item, config.dj_events.dj_name, config.dj_events.default_title)
					event_playlist.set_output_path (events_file_path)
					event_playlist.store
				end
			end
			log.exit
		end

	export_music_to_device
		local
			device: like new_device
		do
			log.enter ("export_music_to_device")
			log_or_io.set_timer
			device := new_device
			if device.volume.is_valid then
				if config.selected_genres.is_empty then
					device.export_songs_and_playlists (songs_all)
				else
					across config.selected_genres as genre loop
						if Database.is_valid_genre (genre.item) then
							log_or_io.put_string_field ("Genre " + genre.cursor_index.out, genre.item)
						else
							log_or_io.put_string_field ("Invalid genre", genre.item)
						end
						log_or_io.put_new_line
					end
					export_to_device (device, song_in_some_playlist (Database) or song_one_of_genres (config.selected_genres))
				end
			else
				notify_invalid_volume
			end
			log_or_io.put_elapsed_time
			log.exit
		end

	export_playlists_to_device
		local
			device: like new_device
		do
			log.enter ("export_playlists_to_device")
			device := new_device
			if device.volume.is_valid then
				export_to_device (device, song_in_some_playlist (Database))
			else
				notify_invalid_volume
			end
			log.exit
		end

	import_videos
			--
		local
			import_notes: like Video_import_notes; done: BOOLEAN
			song_count: INTEGER
		do
			log_or_io.put_line ("VIDEO IMPORT NOTES")
			import_notes := Video_import_notes #$ [Video_extensions]
			across import_notes.lines as line loop
				log_or_io.put_line (line.item)
			end
			song_count := Database.songs.count
			log_or_io.put_new_line
			across Video_extensions.split (',') as extension loop
				across File_system.file_list (Database.mp3_root_location, "*." + extension.item) as video_path loop
					log_or_io.put_path_field ("Found", video_path.item.relative_path (Database.mp3_root_location))
					log_or_io.put_new_line
					from done := False until done loop
						Database.extend (new_video_song (video_path.item))
						done := not video_contains_another_song
					end
					File_system.delete_file (video_path.item)
				end
			end
			if Database.songs.count > song_count then
				Database.store_all
			end
		end

feature -- Tasks: Tag editing

	add_album_art
		local
			pictures: EL_ZSTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
			picture: EL_ID3_ALBUM_PICTURE
			jpeg_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("add_album_art")
			jpeg_path_list := File_system.file_list (config.album_art_dir, "*.jpeg")
			create pictures.make_equal (jpeg_path_list.count)
			across jpeg_path_list as jpeg_path loop
				create picture.make_from_file (jpeg_path.item, jpeg_path.item.parent.steps.last)
				pictures [jpeg_path.item.without_extension.base] := picture
			end
			for_all_songs (
				not song_is_hidden and song_has_artist_or_album_picture (pictures),
				agent Database.add_song_picture (?, ?, ?, pictures)
			)
			Database.store_all
			log.exit
		end

	delete_comments
			-- Delete comments except 'c0'
		do
			log.enter ("delete_comments")
			for_all_songs_id3_info (not song_is_hidden, agent Database.delete_id3_comments)
			Database.store_all
			log.exit
		end

	normalize_comments
			-- Rename 'Comment' comments as 'c0'
			-- This is an antidote to a bug in Rhythmbox version 2.97 where editions to
			-- 'c0' command are saved as 'Comment' and are no longer visible on reload.
		do
			log.enter ("delete_comments")
			for_all_songs_id3_info (not song_is_hidden, agent Database.normalize_comment)
			Database.store_all
			log.exit
		end

	print_comments
		do
			log.enter ("print_comments")
			for_all_songs_id3_info (not song_is_hidden, agent Database.print_id3_comments)
			log.exit
		end

	remove_all_ufids
			--
		do
			log.enter ("remove_all_ufids")
			for_all_songs (not song_is_hidden, agent Database.remove_ufid)
			Database.store_all
			log.exit
		end

	remove_unknown_album_pictures
		do
			log.enter ("remove_unknown_album_pictures")
			for_all_songs (
				not song_is_hidden and song_has_unknown_artist_and_album, agent Database.remove_unknown_album_picture
			)
			Database.store_all
			log.exit
		end

	rewrite_incomplete_id3_info
		do
			log.enter ("rewrite_incomplete_id3_info")
			for_all_songs (not song_is_hidden, agent Database.rewrite_id3_info)
			log.exit
		end

	update_comments_with_album_artists
			--
		do
			log.enter ("update_comments_with_album_artists")
			for_all_songs (not song_is_hidden, agent Database.update_song_comment_with_album_artists)
			Database.store_all
			log.exit
		end

feature {NONE} -- Factory

	new_device: STORAGE_DEVICE
		do
			if config.volume.type.as_lower ~ Device_type.nokia_phone then
				create {NOKIA_PHONE_DEVICE} Result.make (config, Database)

			elseif config.volume.type.as_lower ~ Device_type.samsung_tablet then
				create {SAMSUNG_TABLET_DEVICE} Result.make (config, Database)

			elseif config.playlist_export.root.count > 1
				and then config.playlist_export.root.unicode_item (1).is_alpha
				and then config.playlist_export.root [2] = ':'
			then
				create {NOKIA_PHONE_DEVICE} Result.make (config, Database)

			else
				create Result.make (config, Database)
			end
		end

	new_input_song_time (prompt: ZSTRING): TIME
		local
			time_str: STRING
		do
			time_str := User_input.line (prompt).to_string_8
			if not time_str.has ('.') then
				time_str.append (".000")
			end
			if Time.is_valid_fine (time_str) then
				create Result.make_from_string (time_str, Fine_time_format)
			else
				create Result.make_by_seconds (0)
			end
		end

	new_menu_option_input (prompt: ZSTRING; menu: EL_ZSTRING_LIST): INTEGER
		local
			is_valid: BOOLEAN
		do
			log_or_io.put_line (prompt)
			across menu as option loop
				log_or_io.put_labeled_string (option.cursor_index.out, option.item)
				log_or_io.put_new_line
			end
			log_or_io.put_new_line
			from until is_valid loop
				Result := User_input.integer ("Enter a number")
				log_or_io.put_new_line
				if menu.valid_index (Result) then
					is_valid := True
				else
					log_or_io.put_line ("Invalid option")
					log_or_io.put_new_line
				end
			end
		end

	new_song_info_input (duration_time: TIME_DURATION; default_title, lead_artist: ZSTRING): like Type_song_info
		local
			zero: DOUBLE
		do
			create Result
			Result.time_from := new_input_song_time ("From time")
			Result.time_to := new_input_song_time ("To time")
			if Result.time_to.fine_seconds ~ zero then
				Result.time_to := new_time (duration_time.fine_seconds_count)
			end
			Result.beats_per_minute := User_input.integer ("Post play silence (secs)")
			Result.title := User_input.line ("Title")
			if Result.title.is_empty then
				Result.title := default_title
			end
			Result.album_name := User_input.line ("Album name")
			if Result.album_name ~ Ditto then
				Result.album_name := last_album_name
				log_or_io.put_labeled_string ("Using album name", last_album_name)
				log_or_io.put_new_line
			elseif Result.album_name.is_empty then
				Result.album_name := lead_artist
			end
			last_album_name := Result.album_name
			Result.album_artists := User_input.line ("Album artists")
			Result.recording_year := User_input.integer ("Recording year")
		end

	new_substitution: TUPLE [deleted_path, replacement_path: EL_FILE_PATH]
		do
			create Result
			Result.deleted_path := User_input.file_path ("Song to remove")
			log_or_io.put_new_line
			Result.replacement_path := User_input.file_path ("Song replacement")
			log_or_io.put_new_line
		end

	new_substitution_list: LINKED_LIST [like new_substitution]
		local
			done: BOOLEAN
		do
			create Result.make
			from until done loop
				Result.extend (new_substitution)
				done := Result.last.deleted_path.is_empty and Result.last.replacement_path.is_empty
			end
			Result.finish
			Result.remove
		end

	new_time (fine_seconds: DOUBLE): TIME
		do
			create Result.make_by_fine_seconds (fine_seconds)
		end

	new_video_song (video_path: EL_FILE_PATH): RBOX_SONG
		local
			video_properties: like Audio_command.new_audio_properties
			video_to_mp3_command: like Audio_command.new_video_to_mp3
			genre_path, artist_path: EL_DIR_PATH; song_info: like Type_song_info
			duration_time: TIME_DURATION
		do
			artist_path := video_path.parent; genre_path := artist_path.parent
			video_properties := Audio_command.new_audio_properties (video_path)
			song_info := new_song_info_input (video_properties.duration, video_path.without_extension.base, artist_path.base)
			Result := database.new_song
			Result.set_title (song_info.title)
			Result.set_artist (artist_path.base)
			Result.set_genre (genre_path.base)
			if song_info.recording_year > 0 then
				Result.set_recording_year (song_info.recording_year)
			end
			if Database.silence_intervals.valid_index (song_info.beats_per_minute) then
				Result.set_beats_per_minute (song_info.beats_per_minute)
			end
			Result.set_album (song_info.album_name)
			Result.set_album_artists_list (song_info.album_artists)
			Result.set_mp3_path (Result.unique_normalized_mp3_path)

			video_to_mp3_command := Audio_command.new_video_to_mp3 (video_path, Result.mp3_path)

			if song_info.time_from.seconds > 0
				or song_info.time_to.fine_seconds /~ video_properties.duration.fine_seconds_count
			then
				video_to_mp3_command.set_offset_time (song_info.time_from)
				duration_time := song_info.time_to.relative_duration (song_info.time_from)
				-- duration has extra 0.001 secs added to prevent rounding error below the required duration
				duration_time.fine_second_add (0.001)
				video_to_mp3_command.set_duration (duration_time)
				Result.set_duration (duration_time.fine_seconds_count.rounded)
			end
			if song_info.beats_per_minute > 0 then
				Result.set_beats_per_minute (song_info.beats_per_minute)
			end
			-- Increase bitrate by 64 for AAC -> MP3 conversion
			video_to_mp3_command.set_bit_rate (video_properties.standard_bit_rate + 64)
			log_or_io.put_string ("Converting..")
			video_to_mp3_command.execute
			Result.save_id3_info
			log_or_io.put_new_line
		end

feature {NONE} -- Implementation

	ask_user_for_dir_path (name: ZSTRING)
		do
			dir_path := User_input.dir_path (Drag_and_drop_template #$ [name])
			log_or_io.put_new_line
		end

	ask_user_for_file_path (name: ZSTRING)
		do
			file_path := User_input.file_path (Drag_and_drop_template #$ [name])
			log_or_io.put_new_line
		end

	ask_user_for_task
		local
			config_file_path: EL_FILE_PATH; done: BOOLEAN
		do
			from until done loop
				config_file_path := User_input.file_path ("Drag and drop a task")
				if config_file_path.base ~ Quit then
					done := True; user_quit := True

				elseif config_file_path.exists then
					if File_system.line_one (config_file_path).starts_with ("pyxis-doc:") then
						create config.make_from_file (config_file_path)
						done := True
					else
						log_or_io.put_line ("File is not a valid pyxis document")
					end
				end
				log_or_io.put_new_line
			end
		end

	database_dir_path: EL_DIR_PATH
		do
			Result := xml_database_file_path.parent
		end

	export_to_device (device: like new_device; a_condition: EL_QUERY_CONDITION [RBOX_SONG])
		local
			name_clashes: like Database.case_insensitive_name_clashes
		do
			name_clashes := Database.case_insensitive_name_clashes
			if name_clashes.is_empty then
				device.export_songs_and_playlists (a_condition)
			else
				-- A problem on NTFS and FAT32 filesystems
				log_or_io.put_line ("CASE INSENSITIVE NAME CLASHES FOUND")
				log_or_io.put_new_line
				across name_clashes as path loop
					log_or_io.put_path_field ("MP3", path.item)
					log_or_io.put_new_line
				end
				log_or_io.put_new_line
				log_or_io.put_line ("Fix before proceeding")
			end
		end

	for_all_songs (
		condition: EL_QUERY_CONDITION [RBOX_SONG]
		do_with_song_id3: PROCEDURE [like Database, TUPLE [RBOX_SONG, EL_FILE_PATH, EL_ID3_INFO]]
	)
			--
		local
			song: RBOX_SONG
		do
			across Database.songs.query (condition) as query loop
				song := query.item
				do_with_song_id3 (song, song.mp3_relative_path, song.id3_info)
			end
		end

	for_all_songs_id3_info (
		condition: EL_QUERY_CONDITION [RBOX_SONG]
		do_id3_edit: PROCEDURE [ID3_EDITS, TUPLE [EL_ID3_INFO, EL_FILE_PATH]]
	)
			--
		local
			song: RBOX_SONG
		do
			across Database.songs.query (condition) as query loop
				song := query.item
				do_id3_edit (song.id3_info, song.mp3_relative_path)
			end
		end

	get_cortina_source_and_duration: TUPLE [clip_duration: INTEGER; source_path: EL_FILE_PATH]
		do
			create Result
			Result.clip_duration := User_input.integer ("Clip duration")
			log_or_io.put_line ("CLOSE RHYTHMBOX BEFORE CONTINUING")
			Result.source_path := User_input.file_path ("Cortina song ")
		end

	notify_invalid_volume
		do
			log_or_io.put_labeled_string ("Volume not mounted", config.volume.name)
			log_or_io.put_new_line
		end

	task_table: EL_HASH_TABLE [PROCEDURE [RHYTHMBOX_MUSIC_MANAGER, TUPLE], like config.task]
		do
			create Result.make (<<
				[Task_add_album_art, 							agent add_album_art],
				[Task_collate_songs, 							agent collate_songs],
				[Task_delete_comments, 							agent delete_comments],
				[Task_display_music_brainz_info, 			agent display_music_brainz_info],
				[Task_export_dj_events,							agent export_dj_events],
				[Task_export_music_to_device,					agent export_music_to_device],
				[Task_export_playlists_to_device, 			agent export_playlists_to_device],
				[Task_import_videos, 							agent import_videos],
				[Task_normalize_comments, 						agent normalize_comments],
				[Task_print_comments, 							agent print_comments],
				[Task_publish_dj_events, 						agent publish_dj_events],
				[Task_relocate_songs, 							agent relocate_songs],
				[Task_remove_all_ufids, 						agent remove_all_ufids],
				[Task_replace_cortina_set,						agent replace_cortina_set],
				[task_replace_songs,								agent replace_songs],
				[Task_rewrite_incomplete_id3_info,			agent rewrite_incomplete_id3_info],
				[Task_remove_unknown_album_pictures, 		agent remove_unknown_album_pictures],
				[Task_update_comments_with_album_artists, agent update_comments_with_album_artists]
			>>)
		end

	video_contains_another_song: BOOLEAN
		do
			log_or_io.put_string ("Extract another song from this video (y/n): ")
			Result := User_input.entered_letter ('y')
			log_or_io.put_new_line
		end

	xml_database_file_path: EL_FILE_PATH
		do
			Result := User_config_dir + "rhythmdb.xml"
		end

feature {NONE} -- Internal attributes

	config: MANAGER_CONFIG

	dir_path: EL_DIR_PATH

	file_path: EL_FILE_PATH

	last_album_name: ZSTRING

feature {NONE} -- Type definitions

	Type_song_info: TUPLE [time_from, time_to: TIME; title, album_artists, album_name: ZSTRING; recording_year, beats_per_minute: INTEGER]
		require
			never_called: False
		once
			create Result
		end

feature {NONE} -- Constants

	Database: RBOX_DATABASE
		once
			create Result.make (xml_database_file_path, config.dj_events.playlist_dir)
		end

	Device_type: TUPLE [samsung_tablet, nokia_phone: ZSTRING]
		once
			create Result
			Result.samsung_tablet := "samsung tablet"
			Result.nokia_phone := "nokia phone"
		end

	Ditto: ZSTRING
		once
			Result := "%""
		end

	Drag_and_drop_template: ZSTRING
		once
			Result := "Drag and drop %S here"
		end

	Fine_time_format: STRING = "mi:ss.ff3"

	Quit: ZSTRING
		once
			Result := "quit"
		end

	Video_extensions: STRING = "flv,m4a,m4v,mp4,mov"

	Video_import_notes: ZSTRING
			-- '#' is the same as '%S'
		once
			Result := "[
				Place videos (or m4a audio files) in genre/artist folder.
				Imports files with extensions: #.
				Leave blank fields for the default. Default title is parent directory.
				To duplicate previous album name enter " (for ditto).
				Input offset times are in mm:ss[.xxx] form. If recording year is unknown, enter 0.
			]"
		end

end
