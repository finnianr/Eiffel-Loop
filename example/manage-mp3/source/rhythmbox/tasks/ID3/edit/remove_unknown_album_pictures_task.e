note
	description: "Remove unknown album pictures task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-05 16:01:27 GMT (Tuesday 5th November 2019)"
	revision: "4"

class
	REMOVE_UNKNOWN_ALBUM_PICTURES_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.for_all_songs (
				not song_is_hidden and song_has_unknown_artist_and_album, agent remove_unknown_album_picture
			)
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	remove_unknown_album_picture (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: ID3_INFO)
		do
			if id3_info.has_album_picture and then id3_info.album_picture.description ~ Picture_artist then
				id3_info.remove_album_picture
				Musicbrainz_album_id_set.do_all (agent id3_info.remove_user_text)
				id3_info.update
				song.set_album_picture_checksum (0)
				lio.put_path_field ("Removed album picture", relative_song_path)
				lio.put_new_line
			end
		end

end
