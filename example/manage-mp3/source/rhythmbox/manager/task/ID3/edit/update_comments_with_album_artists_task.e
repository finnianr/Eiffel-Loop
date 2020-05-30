note
	description: "Update comments with album artists task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-30 11:40:17 GMT (Saturday 30th May 2020)"
	revision: "8"

class
	UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK

inherit
	ID3_TASK

	DATABASE_UPDATE_TASK

	EL_STRING_8_CONSTANTS

create
	make

feature -- Basic operations

	apply
		do
			Database.for_all_songs (any_song, agent update_song_comment_with_album_artists)
			Database.store_all
		end

feature {NONE} -- Implementation

	update_song_comment_with_album_artists (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: TL_MPEG_FILE)
			--
		local
			l_album_artists: ZSTRING
		do
			l_album_artists := song.album_artist

			-- Due to a bug in Rhythmbox, it is not possible to set album-artist to zero length
			-- As a workaround, setting album-artist to '--' will cause it to be deleted

			if song.album_artists.list.count = 1 and song.album_artists.list.first ~ song.artist
				or else song.album_artist.is_equal (Double_dash)
			then
				song.set_album_artists (Empty_string)
				id3_info.tag.set_album_artist (Empty_string)
				l_album_artists := song.album_artist
			end
			if l_album_artists /~ id3_info.tag.comment_with (ID3_frame.c0).text then
				print_id3 (id3_info, relative_song_path)
				lio.put_string_field ("Album artists", l_album_artists)
				lio.put_new_line
				lio.put_string_field (ID3_frame.c0, id3_info.tag.comment_with (ID3_frame.c0).text)
				lio.put_new_line
				if l_album_artists.is_empty then
					id3_info.tag.remove_comment (ID3_frame.c0)
				else
					id3_info.tag.set_comment_with (ID3_frame.c0, l_album_artists)
				end
				id3_info.save
			end
		end

feature {NONE} -- Constants

	Double_dash: ZSTRING
		once
			Result := "--"
		end

end
