note
	description: "Summary description for {RBOX_QUERY_CONDITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SONG_QUERY_CONDITIONS

inherit
	EL_QUERY_CONDITION_FACTORY [RBOX_SONG]
		rename
			any as songs_all
		export
			{NONE} all
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Conditions

	song_contains_path_step (a_path_step: ASTRING): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; path_step: ASTRING): BOOLEAN
				do
					if path_step.is_empty then
						Result := True
					else
						Result := song.mp3_path.parent.steps.has (path_step)
					end
				end (?, a_path_step)
			)
		end

	song_in_playlist (a_database: RBOX_DATABASE): PLAYLIST_MEMBER_QUERY_CONDITION
		do
			create Result.make (a_database)
		end

	song_is_cortina: like predicate
		do
			Result := predicate (agent {RBOX_SONG}.is_cortina)
		end

	song_is_hidden: like predicate
		do
			Result := predicate (agent {RBOX_SONG}.is_hidden)
		end

	song_is_modified: like predicate
		do
			Result := predicate (agent {RBOX_SONG}.is_modified)
		end

	song_is_new_export (a_sync_info: DEVICE_SYNC_INFO_TABLE): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; sync_info: DEVICE_SYNC_INFO_TABLE): BOOLEAN
				do
					Result := not sync_info.has_key (song.track_id)

				end (?, a_sync_info)
			)
		end

	song_is_genre (a_genre: ASTRING): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; genre: ASTRING): BOOLEAN
				do
					if genre.is_empty then
						Result := True
					else
						Result := song.genre ~ genre
					end
				end (?, a_genre)
			)
		end

	song_is_generally_tango: like predicate
		do
			Result := predicate (agent (song: RBOX_SONG): BOOLEAN
				do
					Result := across General_tango_genres as genre some song.genre.starts_with (genre.item) end
				end
			)
		end

	song_is_updated_export (a_sync_info: DEVICE_SYNC_INFO_TABLE): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; sync_info: DEVICE_SYNC_INFO_TABLE): BOOLEAN
				do
					sync_info.search (song.track_id)
					Result := sync_info.found and then sync_info.found_item.checksum /= song.last_checksum

				end (?, a_sync_info)
			)
		end

	song_has_artist_and_title (a_artist, a_title: ASTRING): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; artist, title: ASTRING): BOOLEAN
				do
					Result := song.artist ~ artist and song.title ~ title

				end (?, a_artist, a_title)
			)
		end

	song_has_album_artists: like predicate
		do
			Result := predicate (agent (song: RBOX_SONG): BOOLEAN
				do
					Result := not song.album_artists_list.is_empty
				end
			)
		end

	song_has_album_name (a_name: ASTRING): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; name: ASTRING): BOOLEAN
				do
					Result := song.album ~ name

				end (?, a_name)
			)
		end

	song_has_artist_or_album_picture (
		pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
	): EL_OR_QUERY_CONDITION [RBOX_SONG]
		do
			Result := song_has_artist_picture (pictures) or song_has_album_picture (pictures)
		end

	song_has_artist_picture (a_pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): BOOLEAN
				do
					pictures.search (song.artist)
					if pictures.found then
						Result := pictures.found_item.description ~ Picture_artist
					end

				end (?, a_pictures)
			)
		end

	song_has_album_picture (a_pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]): BOOLEAN
				do
					pictures.search (song.album)
					if pictures.found then
						Result := pictures.found_item.description ~ Picture_album
					end

				end (?, a_pictures)
			)
		end

	song_has_multiple_owners_for_id3_ufid: like predicate
		do
			Result := predicate (agent (song: RBOX_SONG): BOOLEAN
				local
					id3_tag: EL_ID3_INFO
				do
					create id3_tag.make (song.mp3_path)
					Result := id3_tag.has_multiple_owners_for_UFID
				end
			)
		end

	song_has_mp3_path (a_mp3_path: EL_FILE_PATH): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; mp3_path: EL_FILE_PATH): BOOLEAN
				do
					Result := song.mp3_path ~ mp3_path
				end (?, a_mp3_path)
			)
		end

	song_has_normalized_mp3_path: like predicate
		do
			Result := predicate (agent {RBOX_SONG}.is_mp3_path_normalized)
		end

	song_has_unique_id (a_owner: STRING): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; owner: STRING): BOOLEAN
				local
					id3_tag: EL_ID3_INFO
				do
					create id3_tag.make (song.mp3_path)
					Result := id3_tag.has_unique_id (owner)

				end (?, a_owner)
			)
		end

	song_has_unidentified_comment: like predicate
		do
			Result := predicate (agent (song: RBOX_SONG): BOOLEAN
				local
					id3_tag: EL_ID3_INFO
				do
					create id3_tag.make (song.mp3_path)
					Result := across id3_tag.comment_table as comment some comment.item.description.is_empty end
				end
			)
		end

	song_has_unknown_artist_and_album: like predicate
		do
			Result := predicate (agent (song: RBOX_SONG): BOOLEAN
				do
					Result := song.artist /~ Unknown and then song.album ~ Unknown
				end
			)
		end

	song_in_set (a_track_id_set: DS_HASH_SET [NATURAL_64]): like predicate
		do
			Result := predicate (agent (song: RBOX_SONG; track_id_set: DS_HASH_SET [NATURAL_64]): BOOLEAN
				do
					Result := track_id_set.has (song.track_id)

				end (?, a_track_id_set)
			)
		end

	song_one_of_genres (a_genres: LIST [ASTRING]): like predicate
		require
			object_comparison: a_genres.object_comparison
		do
			Result := predicate (agent (a_song: RBOX_SONG; genres: LIST [ASTRING]): BOOLEAN
				do
					Result := genres.has (a_song.genre)

				end (?, a_genres)
			)
		end

feature {NONE} -- Constants

	Unknown: ASTRING
		once
			Result := "Unknown"
		end

end
