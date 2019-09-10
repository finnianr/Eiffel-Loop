note
	description: "Test import of new MP3 and tag according to genre and artist location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 8:48:27 GMT (Thursday 5th September 2019)"
	revision: "1"

class
	IMPORT_NEW_MP3_TEST_TASK

inherit
	IMPORT_NEW_MP3_TASK
		undefine
			root_node_name
		redefine
			apply
		end

	TEST_MANAGEMENT_TASK
		undefine
			make_default
		end

feature -- Basic operations

	apply
		local
			song1, song2: RBOX_SONG
		do
			song1 := Database.new_song
			song1.set_mp3_path (Database.music_dir + "Tango/Carlos Di Sarli/disarli.mp3")
			song1.set_title ("La Racha")
			song1.set_genre ("Tango")
			song1.set_artist ("Carlos Di Sarli")
			song1.set_album ("Carlos Di Sarli greatest hits")
			song1.set_duration (8)

			song2 := Database.new_song
			song2.set_mp3_path (Database.music_dir + "Vals/Edgardo Donato/estrellita.mp3")
			song2.set_title ("Estrellita Mia")
			song2.set_genre ("Vals")
			song2.set_artist ("Edgardo Donato with Horacio Lagos, Romeo Gavioli and Lita Morales")
			song2.set_album ("Edgardo Donato greatest hits")
			song2.set_duration (5)

			across << song1, song2 >> as song loop
				song.item.update_checksum
				File_system.make_directory (song.item.mp3_path.parent)
				if attached {RBOX_TEST_DATABASE} Database as test then
					OS.move_file (test.cached_song_file_path (song.item), song.item.mp3_path)
				end
			end

			Precursor
			Precursor
		end

end
