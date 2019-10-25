note
	description: "Update comments with album artists task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 15:22:29 GMT (Tuesday   8th   October   2019)"
	revision: "3"

class
	UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent update_song_comment_with_album_artists)
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	update_song_comment_with_album_artists (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			--
		local
			l_album_artists: ZSTRING
		do
			l_album_artists := song.album_artist

			-- Due to a bug in Rhythmbox, it is not possible to set album-artist to zero length
			-- As a workaround, setting album-artist to '--' will cause it to be deleted

			if song.album_artists.list.count = 1 and song.album_artists.list.first ~ song.artist
				or else song.album_artist.is_equal ("--")
			then
				song.set_album_artists ("")
				id3_info.remove_basic_field (Tag.Album_artist)
				l_album_artists := song.album_artist
			end
			if l_album_artists /~ id3_info.comment (ID3_frame_c0) then
				print_id3 (id3_info, relative_song_path)
				lio.put_string_field ("Album artists", l_album_artists)
				lio.put_new_line
				lio.put_string_field (ID3_frame_c0, id3_info.comment (ID3_frame_c0))
				lio.put_new_line
				if l_album_artists.is_empty then
					id3_info.remove_comment (ID3_frame_c0)
				else
					id3_info.set_comment (ID3_frame_c0, l_album_artists)
				end
				id3_info.update
			end
		end


end
