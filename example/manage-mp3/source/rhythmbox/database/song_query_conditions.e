note
	description: "[
		Song query conditions for use with [$source EL_CHAIN] routines
		
			query
			query_if
			inverse_query_if
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-03 15:58:09 GMT (Wednesday 3rd March 2021)"
	revision: "19"

class
	SONG_QUERY_CONDITIONS

inherit
	EL_QUERY_CONDITION_FACTORY [RBOX_SONG]
		rename
			any as any_song
		export
			{NONE} all
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Query conditions

	song_has_audio_id: like predicate
		do
			Result := agent {RBOX_SONG}.has_audio_id
		end

	song_has_music_brainz_track_id: like predicate
		do
			Result := agent {RBOX_SONG}.has_audio_id
		end

	song_has_normalized_mp3_path: like predicate
		do
			Result := agent {RBOX_SONG}.is_mp3_path_normalized
		end

	song_in_some_playlist (database: RBOX_DATABASE): SONG_IN_PLAYLIST_QUERY_CONDITION
		do
			create Result.make (database)
		end

	song_is_cortina: like predicate
		do
			Result := agent {RBOX_SONG}.is_cortina
		end

	song_is_genre (a_genre: ZSTRING): like predicate
		do
			Result := agent song_genre_matches (?, a_genre)
		end

	song_is_hidden: like predicate
		do
			Result := agent {RBOX_SONG}.is_hidden
		end

	song_is_modified: like predicate
		do
			Result := agent {RBOX_SONG}.is_modified
		end

	song_one_of_genres (a_genres: LIST [ZSTRING]): like predicate
		require
			object_comparison: a_genres.object_comparison
		do
			Result := agent song_genre_in_list (?, a_genres)
		end

feature {NONE} -- Query predicates

	song_contains_path_step (song: RBOX_SONG; path_step: ZSTRING): BOOLEAN
		do
			if path_step.is_empty then
				Result := True
			else
				Result := song.mp3_path.has_step (path_step)
			end
		end

	song_genre_in_list (a_song: RBOX_SONG; genres: LIST [ZSTRING]): BOOLEAN
		do
			Result := genres.has (a_song.genre)
		end

	song_genre_matches (song: RBOX_SONG; genre: ZSTRING): BOOLEAN
		do
			if genre.is_empty then
				Result := True
			else
				Result := song.genre ~ genre
			end
		end

	song_has_album_artists (song: RBOX_SONG): BOOLEAN
		do
			Result := not song.album_artists.list.is_empty
		end

	song_has_album_name (song: RBOX_SONG; name: ZSTRING): BOOLEAN
		do
			Result := song.album ~ name
		end

	song_has_artist_and_title (song: RBOX_SONG; artist, title: ZSTRING): BOOLEAN
		do
			Result := song.artist ~ artist and song.title ~ title
		end

	song_has_mp3_path (song: RBOX_SONG; mp3_path: EL_FILE_PATH): BOOLEAN
		do
			Result := song.mp3_path ~ mp3_path
		end

	song_has_multiple_owners_for_id3_ufid (song: RBOX_SONG): BOOLEAN
		local
			id3_tag: TL_MPEG_FILE
		do
			create id3_tag.make (song.mp3_path)
			Result := across id3_tag.tag.unique_id_group_table as group some group.item.count > 1 end
		end

	song_has_title_substring (song: RBOX_SONG; substring: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := song.title.has_substring (substring)
		end

	song_has_unidentified_comment (song: RBOX_SONG): BOOLEAN
		local
			id3_tag: TL_MPEG_FILE
		do
			create id3_tag.make (song.mp3_path)
			Result := across id3_tag.tag.comment_list as comment some comment.item.description.is_empty end
		end

	song_has_unique_id (song: RBOX_SONG; owner: STRING): BOOLEAN
		local
			id3_tag: TL_MPEG_FILE
		do
			create id3_tag.make (song.mp3_path)
			Result := id3_tag.tag.has_unique_id_with (owner)
		end

	song_has_unknown_artist_and_album (song: RBOX_SONG): BOOLEAN
		do
			Result := song.artist /~ Unknown_string and then song.album ~ Unknown_string
		end

	song_in_set (song: RBOX_SONG; audio_id_set: EL_HASH_SET [STRING]): BOOLEAN
		do
			Result := audio_id_set.has (song.audio_id)
		end

	song_is_generally_tango (song: RBOX_SONG): BOOLEAN
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := Tango_genre_list.there_exists (agent s.starts_with (song.genre, ?))
		end

note
	descendants: "[
			SONG_QUERY_CONDITIONS
				[$source STORAGE_DEVICE]
					[$source NOKIA_PHONE_DEVICE]
					[$source SAMSUNG_TABLET_DEVICE]
					[$source TEST_STORAGE_DEVICE]
				[$source RBOX_DATABASE]
				[$source RBOX_MANAGEMENT_TASK]*
					[$source DEFAULT_TASK]
					[$source ARCHIVE_SONGS_TASK]
					[$source COLLATE_SONGS_TASK]
					[$source IMPORT_NEW_MP3_TASK]
					[$source IMPORT_VIDEOS_TASK]
						[$source IMPORT_YOUTUBE_M4A_TASK]
						[$source IMPORT_VIDEOS_TEST_TASK]
					[$source IMPORT_M3U_PLAYLISTS_TASK]
					[$source LIST_VOLUMES_TASK]
					[$source PUBLISH_DJ_EVENTS_TASK]
					[$source REPLACE_CORTINA_SET_TASK]
						[$source REPLACE_CORTINA_SET_TEST_TASK]
					[$source REPLACE_SONGS_TASK]
						[$source REPLACE_SONGS_TEST_TASK]
					[$source RESTORE_PLAYLISTS_TASK]
					[$source UPDATE_DJ_PLAYLISTS_TASK]
					[$source ID3_TASK]*
						[$source DELETE_COMMENTS_TASK]
						[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
						[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
						[$source NORMALIZE_COMMENTS_TASK]
						[$source PRINT_COMMENTS_TASK]
						[$source REMOVE_ALL_UFIDS_TASK]
						[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
						[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
						[$source ADD_ALBUM_ART_TASK]
					[$source EXPORT_TO_DEVICE_TASK]*
						[$source EXPORT_MUSIC_TO_DEVICE_TASK]
							[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
	]"
end