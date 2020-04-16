note
	description: "Test set for class [$source IMPORT_NEW_MP3_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 10:53:35 GMT (Thursday 16th April 2020)"
	revision: "1"

class
	IMPORT_NEW_MP3_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [IMPORT_NEW_MP3_TASK]
		redefine
			do_task
		end

feature {NONE} -- Implementation

	do_task
		local
			song1, song2: RBOX_SONG
		do
			song1 := database.new_song
			song1.set_mp3_path (database.music_dir + "Tango/Carlos Di Sarli/disarli.mp3")
			song1.set_title ("La Racha")
			song1.set_genre ("Tango")
			song1.set_artist ("Carlos Di Sarli")
			song1.set_album ("Carlos Di Sarli greatest hits")
			song1.set_duration (8)

			song2 := database.new_song
			song2.set_mp3_path (database.music_dir + "Vals/Edgardo Donato/estrellita.mp3")
			song2.set_title ("Estrellita Mia")
			song2.set_genre ("Vals")
			song2.set_artist ("Edgardo Donato with Horacio Lagos, Romeo Gavioli and Lita Morales")
			song2.set_album ("Edgardo Donato greatest hits")
			song2.set_duration (5)

			across << song1, song2 >> as song loop
				song.item.update_checksum
				File_system.make_directory (song.item.mp3_path.parent)
				OS.move_file (database.cached_song_file_path (song.item), song.item.mp3_path)
			end

			task.apply; task.apply

			print_rhythmdb_xml; print_playlist_xml
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2894564646

	Task_config: STRING = "[
		import_new_mp3:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"
end
