note
	description: "Test variation of [$source ADD_ALBUM_ART_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-03 14:27:04 GMT (Friday 3rd April 2020)"
	revision: "3"

class
	ADD_ALBUM_ART_TEST_TASK

inherit
	ADD_ALBUM_ART_TASK
		undefine
			root_node_name
		redefine
			apply
		end

	TEST_MANAGEMENT_TASK
		undefine
			make
		end

feature -- Basic operations

	apply
		do
			Precursor
			log.enter ("update_pictures")
			update_pictures
			log.exit
			verify_mb_track_id
		end

feature {NONE} -- Implementation

	verify_mb_track_id
		local
			mp3: EL_MP3_IDENTIFIER
		do
			log.enter ("verify_mb_track_id")
			across Database.songs.query (not song_is_hidden) as song loop
				create mp3.make (song.item.mp3_path)
				if not mp3.audio_id.to_delimited (':').is_equal (song.item.audio_id) then
					log.put_labeled_string ("Invalid audio_id", song.item.mp3_path.base)
					log.put_new_line
				end
			end
			log.exit
		end

end
