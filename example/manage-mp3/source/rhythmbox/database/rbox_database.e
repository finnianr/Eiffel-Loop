note
	description: "[
		Database of all Rhythmbox songs, playlists, radio entries and ignored entries.
		It is read from these files:
			$HOME/.local/share/rhythmbox/rhythmdb.xml
			$HOME/.local/share/rhythmbox/playlists.xml
			$HOME/Music/Playlists/*.pyx
			
		The `*.pyx' ones are playlists which have been saved using the `update_dj_playlists' task.
			
		Note that this database save modifications to songs and playlists.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-28 12:02:18 GMT (Wednesday 28th September 2016)"
	revision: "3"

class
	RBOX_DATABASE

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		rename
			output_path as xml_database_path,
			set_output_path as set_xml_database_path,
			store as store_entries
		redefine
			store_entries, getter_function_table, on_context_return
		end

	MARKUP_LINE_COUNTER
		undefine
			is_equal, copy
		end

	ID3_EDITS

	SONG_QUERY_CONDITIONS

	EL_MODULE_ARGS

	EL_MODULE_LOG

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_BUILD_INFO

create
	make

feature {NONE} -- Initialization

	make (a_xml_database_path: EL_FILE_PATH; a_music_dir: like music_dir)
			--
		do
			music_dir := a_music_dir

			lio.put_path_field ("Reading", a_xml_database_path)
			lio.put_new_line
		 	create entries.make (1000)
			create songs_by_location.make_equal (entries.capacity)
			create songs_by_audio_id.make_equal (entries.capacity)
			create songs.make (entries.capacity)
		 	create silence_intervals.make_filled (new_song, 1, 3)
			create dj_playlists.make (20)

			File_system.make_directory (dj_playlist_dir)

			if a_xml_database_path.exists then
			 	songs.grow (line_ends_with_count (a_xml_database_path, "type=%"song%">"))
				entries.grow (songs.capacity + 50)
				create songs_by_location.make (entries.capacity)
				create songs_by_audio_id.make (entries.capacity)
			end

			make_from_file (a_xml_database_path)
			lio.put_new_line

			playlists_xml_path := xml_database_path.parent + "playlists.xml"
			create playlists.make (playlists_xml_path, Current)
			is_initialized := not songs.is_empty
		end

feature -- Access

	playlists_all: EL_ARRAYED_LIST [PLAYLIST]
		do
			create Result.make (playlists.count + dj_playlists.count)
			Result.append (playlists)
			Result.append (dj_playlists)
		end

	title_and_album (mp3_path: EL_FILE_PATH): ZSTRING
		do
			songs_by_location.search (mp3_path)
			if songs_by_location.found then
				Result := songs_by_location.found_item.title_and_album
			else
				create Result.make_empty
			end
		end

	archive_playlist: RBOX_PLAYLIST
		do
			playlists.find_first (Archive, agent {RBOX_PLAYLIST}.name)
			if playlists.exhausted then
				create Result.make (Current)
			else
				Result := playlists.item
			end
		end

	case_insensitive_name_clashes: LINKED_LIST [EL_FILE_PATH]
			-- list of mp3 paths having base names that clash with another in same directory
			-- when compared without case insensitivity.
		local
			path_list: EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
			name_set: EL_HASH_SET [EL_FILE_PATH]; last_dir: EL_DIR_PATH
		do
			create name_set.make_equal (11); create last_dir
			create path_list.make (songs.count)
			create Result.make
			across songs as song loop
				path_list.extend (song.item.mp3_relative_path)
			end
			path_list.sort
			across path_list as file_path loop
				if last_dir /~ file_path.item.parent then
					name_set.wipe_out
					last_dir := file_path.item.parent
				end
				name_set.put (file_path.item.base.as_lower)
				if name_set.conflict then
					Result.extend (file_path.item)
				end
			end
		end

feature -- Access attributes

	entries: EL_ARRAYED_LIST [RBOX_IRADIO_ENTRY]

	songs: EL_QUERYABLE_ARRAYED_LIST [RBOX_SONG]

	playlists: RBOX_PLAYLIST_ARRAY

	dj_playlists: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
		-- Playlists with DJ event information stored in $HOME/Music/Playlists using Pyxis format

	playlists_xml_path: EL_FILE_PATH

	music_dir: EL_DIR_PATH

	songs_by_location: HASH_TABLE [RBOX_SONG, EL_FILE_PATH]

	songs_by_audio_id: HASH_TABLE [RBOX_SONG, EL_UUID]

	silence_intervals: ARRAY [RBOX_SONG]

	version: REAL

	dj_playlist_dir: EL_DIR_PATH
		do
			Result := music_dir.joined_dir_path ("Playlists")
		end

feature -- Factory

	new_song: RBOX_SONG
		do
			create Result.make (Current)
		end

	new_playlist (a_name: STRING): RBOX_PLAYLIST
		do
			create Result.make_with_name (a_name, Current)
		end

feature -- Status query

	is_initialized: BOOLEAN

	has_song (song_path: EL_FILE_PATH): BOOLEAN
		do
			Result := songs_by_location.has (song_path)
		end

	is_valid_genre (a_genre: ZSTRING): BOOLEAN
		do
			Result := across songs as song
				some
					song.item.genre ~ a_genre
				end
		end

	is_song_in_any_playlist (song: RBOX_SONG): BOOLEAN
		local
			l_music_extra_playlist: like archive_playlist
		do
			l_music_extra_playlist := archive_playlist
			Result := across playlists_all as playlist some
				playlist.item /= l_music_extra_playlist and then playlist.item.has (song)
			end
		end

feature -- Element change

	extend (a_entry: RBOX_IRADIO_ENTRY)
		do
			entries.extend (a_entry)
			if attached {RBOX_SONG} a_entry as song and then song.mp3_path.extension ~ Mp3_extension then
				extend_with_song (song)

			elseif attached {RBOX_IGNORED_ENTRY} a_entry as entry and then entry.genre ~ Playlist_genre then
				dj_playlists.extend (create {DJ_EVENT_PLAYLIST}.make_from_file (Current, entry.location))
				entry.set_title (dj_playlists.last.title) -- Override title with the one in the DJ event playlist
			end
		end

	extend_with_song (song: RBOX_SONG)
		local
			audio_id: EL_UUID;
		do
			if not song.has_audio_id then
				song.update_audio_id
			end

			songs_by_location.put (song, song.mp3_path)
			if songs_by_location.conflict then
				lio.put_new_line
				lio.put_path_field ("DUPLICATE", song.mp3_path)
				lio.put_new_line
			else
				songs.extend (song)
				audio_id := song.audio_id
				if audio_id.is_null then
					lio.put_new_line
					lio.put_line ("NULL AUDIO ID")
					lio.put_path_field ("Song", song.mp3_path)
					lio.put_new_line
				else
					songs_by_audio_id.put (song, audio_id)
					if songs_by_audio_id.conflict then
						lio.put_new_line
						lio.put_line ("DUPLICATES")
						lio.put_path_field ("Song 1", songs_by_audio_id.item (audio_id).mp3_path)
						lio.put_new_line
						lio.put_path_field ("Song 2", song.mp3_path)
						lio.put_new_line
					end
				end
				if song.is_genre_silence and then silence_intervals.valid_index (song.duration) then
					silence_intervals [song.duration] := song
				end
			end
		end

	extend_from_playlist (playlist: RBOX_PLAYLIST)
			--
		do
			playlist.do_all (
				agent (song: RBOX_SONG)
					do
						if not song.is_hidden
							and then not songs_by_location.has (song.mp3_path)
						then
							extend (song)
						end
					end
			)
		end

	import_mp3 (mp3_path: EL_FILE_PATH)
		require
			not_already_present: not songs_by_location.has (mp3_path)
		local
			relative_path_steps: EL_PATH_STEPS
			id3_info: EL_ID3_INFO
			song: RBOX_SONG
		do
			log.enter_with_args ("import_mp3", << mp3_path >>)
			relative_path_steps := mp3_path.relative_path (music_dir).steps
			if relative_path_steps.count = 3 then
				create id3_info.make (mp3_path)
				song := new_song
				if id3_info.title.is_empty then
					song.set_title (mp3_path.base_sans_extension)
				else
					song.set_title (id3_info.title)
				end
				song.set_album (id3_info.album)
				song.set_track_number (id3_info.track)
				song.set_recording_year (id3_info.year)

				song.set_genre (relative_path_steps.i_th (1))
				song.set_artist (relative_path_steps.i_th (2))

				song.write_id3_info (id3_info)
				song.set_mp3_path (song.unique_normalized_mp3_path)
				OS.move_file (mp3_path, song.mp3_path)

				extend (song)
				lio.put_path_field ("Imported", song.mp3_relative_path)
				lio.put_new_line
			end
			log.exit
		end

	set_playlists (a_playlists: like playlists)
			--
		do
			playlists := a_playlists
		end

	set_playlists_xml_path (a_playlists_xml_path: STRING)
		do
			playlists_xml_path := a_playlists_xml_path.as_string_32
		end

	replace_cortinas (a_cortina_set: CORTINA_SET)
		local
			directory_set: EL_HASH_SET [EL_DIR_PATH]
			condition: EL_AND_QUERY_CONDITION [RBOX_SONG]
		do
			create directory_set.make_equal (2)
			condition := not song_is_hidden and song_is_genre (Genre_cortina)

			across songs.query (condition) as song loop
				directory_set.put (song.item.mp3_path.parent)
			end
			delete (condition)

			across directory_set as cortina_dir loop
				File_system.delete_if_empty (cortina_dir.item)
			end
			across a_cortina_set as genre loop
				across genre.item as cortina loop
					extend (cortina.item)
				end
			end
			playlists_all.do_all (agent {PLAYLIST}.replace_cortinas (a_cortina_set))
		end

	replace (deleted_path, replacement_path: EL_FILE_PATH)
		require
			not_same_song: deleted_path /~ replacement_path
			has_deleted_path: songs_by_location.has (deleted_path)
			has_replacement_path: songs_by_location.has (replacement_path)
		local
			deleted, replacement: RBOX_SONG
		do
			deleted := songs_by_location [deleted_path]
			replacement := songs_by_location [replacement_path]
			playlists_all.do_all (agent {PLAYLIST}.replace_song (deleted, replacement))
		end

	update_index_by_audio_id
		do
			songs_by_audio_id.wipe_out
			songs.do_query (not song_is_hidden)
			across songs.last_query_items as song loop
				songs_by_audio_id.search (song.item.audio_id)
				if not songs_by_audio_id.found then
					songs_by_audio_id.extend (song.item, song.item.audio_id)
				else
					check
						audio_ids_are_unique: False
					end
				end
			end
		end

	update_DJ_playlists (dj_name, default_title: ZSTRING)
			-- update DJ event playlists with any new Rhythmbox playlists
		local
			events_file_path: EL_FILE_PATH; entry: RBOX_IGNORED_ENTRY
			parts: EL_ZSTRING_LIST
		do
			across playlists as playlist loop
				parts := playlist.item.name
				if parts.count > 1 and then Date_checker.date_valid (parts [1], once "yyyy-mm-dd") then
					events_file_path := dj_playlist_dir + playlist.item.name
					events_file_path.add_extension ("pyx")
					if not events_file_path.exists then
						dj_playlists.extend (create {DJ_EVENT_PLAYLIST}.make (Current, playlist.item, dj_name, default_title))
						dj_playlists.last.set_output_path (events_file_path)

						create entry.make
						entry.set_genre (Playlist_genre)
						entry.set_title (dj_playlists.last.title)
						entry.set_media_type (Text_pyxis)
						entry.set_location (events_file_path)

						entries.extend (entry)
					end
				end
			end
		end

	new_dj_playlist_entry (playlist: DJ_EVENT_PLAYLIST): RBOX_IGNORED_ENTRY
		do
		end

feature -- Basic operations

	import_m3u_playlist (m3u_playlist: M3U_PLAYLIST_READER)
		do
			lio.put_string_field ("Importing playlist", m3u_playlist.name)
			lio.put_new_line
			playlists.extend (new_playlist (m3u_playlist.name))
			m3u_playlist.do_all (
				agent (path_steps: EL_PATH_STEPS)
					local
						song_path: EL_FILE_PATH
					do
						song_path := music_dir.joined_file_steps (path_steps)
						if has_song (song_path) then
							playlists.last.add_song_from_path (song_path)
							lio.put_path_field ("Imported", song_path)
						else
							lio.put_path_field ("Not found", song_path)
						end
						lio.put_new_line
					end
			)
			lio.put_new_line
		end

	display_incomplete_id3_info (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			-- Display songs with incomplete TXXX ID3 tags
		do
			if across id3_info.user_text_table as user_text
				some
					user_text.item.description.is_empty and then user_text.item.string.is_integer
				end
			then
				print_id3 (id3_info, relative_song_path)
			end
		end

	restore_playlists
			-- restore playlists from playlists.backup.xml
		local
			backup_path: EL_FILE_PATH
		do
			backup_path := playlists_xml_path.with_new_extension ("backup.xml")
			if backup_path.exists then
				lio.put_path_field ("Restoring playlists from", backup_path); lio.put_new_line

				create playlists.make (backup_path, Current)
				OS.delete_file (playlists_xml_path)
				playlists.set_output_path (playlists_xml_path)
				playlists.store
  			else
				lio.put_path_field ("File not found", backup_path); lio.put_new_line
			end
		end

	store_all
			--
		do
			store_entries
			store_playlists
		end

	store_entries
		do
			log.put_line ("Saving entries")
			Precursor
		end

	store_playlists
		do
			log.put_line ("Saving playlists")
			playlists.store
			dj_playlists.do_all (agent {DJ_EVENT_PLAYLIST}.store)
		end

	store_in_directory (a_dir_path: EL_DIR_PATH)
			-- Save database and playlists in location 'a_dir_path'
		local
			l_previous_dir_path: EL_DIR_PATH
		do
			l_previous_dir_path := xml_database_path.parent
			set_xml_database_path (a_dir_path + xml_database_path.base)
			playlists.set_output_path (a_dir_path + playlists.output_path.base)
			store_all
			set_xml_database_path (l_previous_dir_path + xml_database_path.base)
			playlists.set_output_path (l_previous_dir_path + playlists.output_path.base)
		end

feature -- Removal

	remove (song: RBOX_SONG)
			-- remove without deleting file
		require
			not_in_any_playlist: across playlists_all as playlist all not playlist.item.has (song) end
		do
			songs.start; songs.prune (song)
			entries.start; entries.prune (song)
			songs_by_location.remove (song.mp3_path)
			songs_by_audio_id.remove (song.audio_id)
		end

	delete (condition: EL_QUERY_CONDITION [RBOX_SONG])
		local
			song: like songs.item; entry_removed: BOOLEAN
		do
			from songs.start; entries.start until songs.after loop
				song := songs.item
				if condition.include (song) then
					songs_by_location.remove (song.mp3_path)
					songs_by_audio_id.remove (song.audio_id)
					OS.delete_file (song.mp3_path)
					songs.remove
					from entry_removed := False until entries.after or else entry_removed loop
						if song = entries.item then
							entries.remove
							entry_removed := True
						else
							entries.forth
						end
					end
				else
					songs.forth
				end
			end
		ensure
			same_number_removed: old songs.count - songs.count = old entries.count - entries.count
		end

	wipe_out
			--
		do
			entries.wipe_out
			songs.wipe_out
			songs_by_location.wipe_out
			songs_by_audio_id.wipe_out
		end

feature -- Tag editing

	remove_unknown_album_picture (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
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

feature {RHYTHMBOX_MUSIC_MANAGER} -- Tag editing

	add_song_picture (
		song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO
		pictures: EL_ZSTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
	)
		local
			picture: EL_ID3_ALBUM_PICTURE
		do
			if song_has_artist_picture (pictures).include (song) and then not id3_info.has_album_picture then
				picture := pictures [song.artist]

			elseif song_has_album_picture (pictures).include (song) and then song.album /~ Unknown then
				picture := pictures [song.album]

			else
				create picture
			end
			if picture.data.count > 0 and then picture.checksum /= song.album_picture_checksum then
				lio.put_labeled_string ("Setting", picture.description.as_proper_case + " picture")
				lio.put_new_line
				lio.put_path_field ("Song", relative_song_path)
				lio.put_new_line
				lio.put_new_line

				id3_info.set_album_picture (picture)

				-- Both albumid fields need to be set in ID3 info otherwise
				-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
				Musicbrainz_album_id_set.do_all (agent id3_info.set_user_text (?, id3_info.album_picture.checksum.out))
				id3_info.update
				song.set_album_picture_checksum (id3_info.album_picture.checksum)
				song.update_checksum
			end
		end

	remove_ufid (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			--
		do
			if not id3_info.unique_id_list.is_empty then
				print_id3 (id3_info, relative_song_path)
				id3_info.remove_all_unique_ids
				id3_info.update
			end
		end

	update_song_comment_with_album_artists (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			--
		local
			l_album_artists: ZSTRING
		do
			l_album_artists := song.album_artist

			-- Due to a bug in Rhythmbox, it is not possible to set album-artist to zero length
			-- As a workaround, setting album-artist to '--' will cause it to be deleted

			if song.album_artists_list.count = 1 and song.album_artists_list.first ~ song.artist
				or else song.album_artist.is_equal ("--")
			then
				song.set_album_artists_list ("")
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

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["version", agent: REAL_REF do Result := version.to_reference end ],
				["entries", agent: ITERABLE [RBOX_IRADIO_ENTRY] do Result := entries end]
			>>)
		end

feature {NONE} -- Build from XML

	add_song_entry
			--
		do
			if songs.count \\ 10 = 0 or else songs.count = songs.capacity then
				io.put_string (Read_progress_template #$ [songs.count, songs.capacity])
			end
			set_next_context (new_song)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			if attached {RBOX_IRADIO_ENTRY} context as entry then
				extend (entry)
			end
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: rhythmdb
		do
			create Result.make (<<
				["@version", agent do version := node.to_real end],
				["entry[@type='song']", agent add_song_entry],
				["entry[@type='iradio']", agent do set_next_context (create {RBOX_IRADIO_ENTRY}.make) end],
				["entry[@type='ignore']", agent do set_next_context (create {RBOX_IGNORED_ENTRY}.make) end]
			>>)
		end

	Root_node_name: STRING = "rhythmdb"

feature {NONE} -- Constants

	Musicbrainz_album_id_set: ARRAY [ZSTRING]
			-- Both fields need to be set in ID3 info otherwise
			-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
		once
			Result := << "MusicBrainz Album Id", "musicbrainz_albumid" >>
		end

	Archive: ZSTRING
		once
			Result := "Archive"
		end

	Read_progress_template: ZSTRING
		once
			Result := "%RSongs: [%S of %S]"
		end

	Artists_field: ZSTRING
		once
			Result := "Artists: "
		end

	Mp3_extension: ZSTRING
		once
			Result := "mp3"
		end

	Date_checker: DATE_VALIDITY_CHECKER
		once
			create Result
		end

	Playlist_genre: ZSTRING
		-- special genre to mark Rhythmbox ignored entry as a DJ event playlist
		once
			Result := "playlist"
		end

	Unknown_artist_names: ARRAY [ZSTRING]
		once
			Result := << "Various", "Various Artists", "Unknown" >>
			Result.compare_objects
		end

	Template: STRING =
		-- Substitution template

	"[
		<?xml version="1.0" standalone="yes"?>
		<rhythmdb version="$version">
		#across $entries as $entry loop
			#evaluate ($entry.item.template_name, $entry.item)
		#end
		</rhythmdb>
	]"

end
