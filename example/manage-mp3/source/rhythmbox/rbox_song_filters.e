note
	description: "Summary description for {RBOX_SONG_FILTERS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	RBOX_SONG_FILTERS

inherit
	MODULE_RHYTHMBOX

feature -- Postive matches

	is_any (a_song: RBOX_SONG): BOOLEAN
		do
			Result := True
		end

	contains_path_step (song: RBOX_SONG; path_step: EL_ASTRING): BOOLEAN
			--
		do
			if path_step.is_empty then
				Result := True
			else
				Result := song.mp3_path.parent.steps.has (path_step)
			end
		end

	is_with_artist_and_title (song: RBOX_SONG; artist, title: STRING): BOOLEAN
			--
		do
			Result := song.artist ~ artist and song.title ~ title
		end

	is_new_export (song: RBOX_SONG; sync_info: RBOX_SYNC_INFO_TABLE): BOOLEAN
		do
			Result := not sync_info.has_key (song.track_id)
		end

	is_updated_export (song: RBOX_SONG; sync_info: RBOX_SYNC_INFO_TABLE): BOOLEAN
		do
			sync_info.search (song.track_id)
			Result := sync_info.found and then sync_info.found_item.checksum /= song.last_checksum
		end

	is_in_track_id_set (song: RBOX_SONG; track_id_set: DS_HASH_SET [NATURAL_64]): BOOLEAN
		do
			Result := track_id_set.has (song.track_id)
		end

	has_multiple_owners_for_id3_ufid (song: RBOX_SONG): BOOLEAN
		local
			id3_tag: EL_ID3_INFO
		do
			create id3_tag.make (song.mp3_path)
			Result := id3_tag.has_multiple_owners_for_UFID
		end

	has_unique_id (song: RBOX_SONG; owner: STRING): BOOLEAN
		local
			id3_tag: EL_ID3_INFO
		do
			create id3_tag.make (song.mp3_path)
			Result := id3_tag.has_unique_id (owner)
		end

	has_unidentified_comment (song: RBOX_SONG): BOOLEAN
		local
			id3_tag: EL_ID3_INFO
		do
			create id3_tag.make (song.mp3_path)
			Result := across id3_tag.comment_table as comment some comment.item.description.is_empty end
		end

	has_album_artists (song: RBOX_SONG): BOOLEAN
		do
			Result := not song.album_artists_list.is_empty
		end

	has_album_name (song: RBOX_SONG; a_name: EL_ASTRING): BOOLEAN
		do
			Result := song.album ~ a_name
		end

	has_artist_or_album_picture (
		song: RBOX_SONG; pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
	): BOOLEAN
			--
		do
			Result := has_artist_picture (song, pictures) or else has_album_picture (song, pictures)
		end

	has_artist_picture (song: RBOX_SONG; pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): BOOLEAN
		do
			pictures.search (song.artist)
			if pictures.found then
				Result := pictures.found_item.description ~ Rhythmbox.Picture_artist
			end
		end

	has_album_picture (song: RBOX_SONG; pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): BOOLEAN
		do
			pictures.search (song.album)
			if pictures.found then
				Result := pictures.found_item.description ~ Rhythmbox.Picture_album
			end
		end

feature -- Genre filters

	is_in_genre_list (a_song: RBOX_SONG; a_genre_list: LIST [EL_ASTRING]): BOOLEAN
		require
			object_comparison: a_genre_list.object_comparison
		do
			Result := a_genre_list.has (a_song.genre)
		end

	is_of_genre (song: RBOX_SONG; genre: EL_ASTRING): BOOLEAN
			--
		do
			if genre.is_empty then
				Result := True
			else
				Result := song.genre ~ genre
			end
		end

	is_generally_tango (song: RBOX_SONG): BOOLEAN
			--
		do
			Result := across Rhythmbox.General_tango_genres as genre some song.genre.starts_with (genre.item) end
		end

end
