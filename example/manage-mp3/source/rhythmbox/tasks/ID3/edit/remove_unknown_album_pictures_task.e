note
	description: "Remove unknown album pictures task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 14:12:42 GMT (Tuesday 31st March 2020)"
	revision: "7"

class
	REMOVE_UNKNOWN_ALBUM_PICTURES_TASK

inherit
	ID3_TASK

	DATABASE_UPDATE_TASK

	TL_SHARED_MUSICBRAINZ_ENUM

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

	remove_unknown_album_picture (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: TL_MUSICBRAINZ_MPEG_FILE)
		do
			if id3_info.tag.has_picture and then id3_info.tag.picture.description ~ Picture_artist then
				id3_info.tag.remove_picture
				id3_info.remove_mb_field (Musicbrainz.album_id)
				id3_info.save
				song.set_album_picture_checksum (0)
				lio.put_path_field ("Removed album picture", relative_song_path)
				lio.put_new_line
			end
		end

end
