note
	description: "Test set for class ${IMPORT_NEW_MP3_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

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
				song.item.set_modification_time (Test_time)
				File_system.make_directory (song.item.mp3_path.parent)
				OS.move_file (database.cached_song_file_path (song.item), song.item.mp3_path)
			end

			task.apply; task.apply

			print_rhythmdb_xml; print_playlist_xml
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 490029745

	Task_config: STRING = "[
		import_new_mp3:
			music_dir = "workarea/rhythmdb/Music"
	]"

	Test_time: DATE_TIME
		once
			create Result.make (2011, 11, 11, 11, 11, 11)
		end
end