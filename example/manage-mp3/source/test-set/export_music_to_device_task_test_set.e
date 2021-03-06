note
	description: "Test set for class [$source EXPORT_MUSIC_TO_DEVICE_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 15:22:25 GMT (Monday 18th January 2021)"
	revision: "9"

class
	EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [EXPORT_MUSIC_TO_DEVICE_TASK]
		redefine
			do_task, on_prepare
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			-- Delete sync table file cached under Directory.app_data
			task.device.delete_sync_table_file
		end

feature {NONE} -- Implementation

	assert_expected_count (condition: EL_QUERY_CONDITION [RBOX_SONG])
		do
			assert ("expected mp3 count", mp3_file_count = database.existing_songs_query (condition).count)
		end

	do_task
		local
			condition: EL_QUERY_CONDITION [RBOX_SONG]; title: ZSTRING
		do
			condition := song_in_some_playlist (database) or song_one_of_genres (task.selected_genres)

			do_export (task, condition)
			assert ("m3u file for each playlist", m3u_file_count = database.playlists.count)

			log.put_line ("Removing genre: Irish Traditional")
			task.selected_genres.prune ("Irish Traditional")
			task.apply
			assert_expected_count (condition)

			task := new_task (Export_all_code)
			do_export (task, any_song)

			log.put_line ("Hiding Classical songs")
			across database.existing_songs_query (song_is_genre ("Classical")) as song loop
				song.item.hide
			end
			log.put_line ("Changing titles on Rock Songs")
			across database.existing_songs_query (song_is_genre ("Rock")) as song loop
				title := song.item.title
				title.prepend_character ('X')
				song.item.set_title (title)
				song.item.update_checksum
			end
			task.apply
			assert_expected_count (any_song)
		end

	do_export (a_task: RBOX_MANAGEMENT_TASK; condition: EL_QUERY_CONDITION [RBOX_SONG])
		do
			a_task.apply
			assert_expected_count (condition)

			a_task.apply
		end

	mp3_file_count: INTEGER
		do
			Result := OS.file_list (Export_dir, "*.mp3").count
		end

	m3u_file_count: INTEGER
		do
			Result := OS.file_list (Export_playlists_dir, "*.m3u").count
		end

feature {NONE} -- Constants

	Checksum: NATURAL
		once
			Result := 555037765
		end

	Export_dir: EL_DIR_PATH
		once
			Result := Work_area_data_dir.joined_dir_path ("TABLET/Card/Music")
		end


	Export_playlists_dir: EL_DIR_PATH
		once
			Result := Export_dir.joined_dir_path ("playlists")
		end

	Export_all_code: STRING = "[
		export_music_to_device:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"

			volume:
				name = TABLET; type = TEST; destination_dir = "Card/Music"; id3_version = 2.3
	]"

	Task_config: STRING
		once
			Result := "[
				export_music_to_device:
					music_dir = "workarea/rhythmdb/Music"
				
					volume:
						name = TABLET; type = TEST; destination_dir = "Card/Music"; id3_version = 2.3
				
					selected_genres:
						item:
							"Classical"
							"Irish Traditional"
			]"
		end

end