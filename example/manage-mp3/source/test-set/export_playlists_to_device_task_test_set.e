note
	description: "Test set for class [$source EXPORT_MUSIC_TO_DEVICE_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-30 11:29:55 GMT (Saturday 30th May 2020)"
	revision: "6"

class
	EXPORT_PLAYLISTS_TO_DEVICE_TASK_TEST_SET

inherit
	EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET
		redefine
			do_task, task, Checksum, Task_config
		end

feature {NONE} -- Implementation

	do_task
		local
			song_count: INTEGER
		do
			task.apply
			assert_expected_count (song_in_some_playlist (database))
			assert ("m3u file for each playlist", m3u_file_count = database.playlists.count)

			song_count := database.existing_songs_query (song_in_some_playlist (database)).count

			log.put_line ("Removing first playlist")
			-- Expected behaviour is that it shouldn't delete anything
			database.playlists.start
			database.playlists.remove

			task.apply
			assert ("same number of songs", mp3_file_count = song_count)
		end

feature {NONE} -- Internal attributes

	task: EXPORT_PLAYLISTS_TO_DEVICE_TASK

feature {NONE} -- Constants

	Checksum: NATURAL = 26842189

	Task_config: STRING = "[
		export_playlists_to_device:
			music_dir = "workarea/rhythmdb/Music"
			volume:
				name = TABLET; type = TEST; destination_dir = "Card/Music"; id3_version = 2.3
		
			playlist_export:
				root = "/storage/extSdCard"; subdirectory_name = "playlists"
	]"
end
