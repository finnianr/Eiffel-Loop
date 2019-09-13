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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-12 8:58:42 GMT (Thursday 12th September 2019)"
	revision: "16"

class
	RBOX_DATABASE

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
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

	SONG_QUERY_CONDITIONS

	EL_MODULE_ARGS

	EL_MODULE_LOG

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_BUILD_INFO

	EL_MODULE_URL

	SHARED_DATABASE

create
	make

feature {NONE} -- Initialization

	make (a_xml_database_path: EL_FILE_PATH; a_music_dir: like music_dir)
			--
		do
			call (Database)

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
			create playlists.make (playlists_xml_path)
			is_initialized := not songs.is_empty
		end

feature -- Access

	all_playlists: EL_ARRAYED_LIST [PLAYLIST]
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
			playlists.find_first_equal (Archive, agent {RBOX_PLAYLIST}.name)
			if playlists.exhausted then
				create Result.make_default
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

	new_iradio_entry: RBOX_IRADIO_ENTRY
		do
			create Result.make
		end

	new_song: RBOX_SONG
		do
			create Result.make
		end

	new_cortina (a_source_song: RBOX_SONG; a_tanda_type: ZSTRING; a_track_number, a_duration: INTEGER): RBOX_CORTINA_SONG
		do
			create Result.make (a_source_song, a_tanda_type, a_track_number, a_duration)
		end

	new_ignored_entry: RBOX_IGNORED_ENTRY
		do
			create Result.make
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
			Result := across all_playlists as playlist some
				playlist.item /= l_music_extra_playlist and then playlist.item.has (song)
			end
		end

feature -- Element change

	extend (a_entry: RBOX_IRADIO_ENTRY)
		local
			playlist: DJ_EVENT_PLAYLIST
		do
			if attached {RBOX_SONG} a_entry as song and then song.is_mp3_format then
				extend_with_song (song)
				entries.extend (song)

			elseif attached {RBOX_IGNORED_ENTRY} a_entry as ignored and then ignored.is_playlist then
				create playlist.make_from_file (ignored.location)
				dj_playlists.extend (playlist)

				entries.extend (playlist.new_rbox_entry)
			else
				entries.extend (a_entry)
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
			across playlist as song loop
				if not song.item.is_hidden and then not songs_by_location.has (song.item.mp3_path) then
					extend (song.item)
				end
			end
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
			condition := not song_is_hidden and song_is_genre (Extra_genre.cortina)

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
			all_playlists.do_all (agent {PLAYLIST}.replace_cortinas (a_cortina_set))
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
			all_playlists.do_all (agent {PLAYLIST}.replace_song (deleted, replacement))
		end

	update_index_by_audio_id
		do
			songs_by_audio_id.wipe_out
			across songs as song loop
				if not song.item.is_hidden then
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
		end

	update_DJ_playlists (dj_name, default_title: ZSTRING)
			-- update DJ event playlists with any new Rhythmbox playlists
		local
			dj_playlist: DJ_EVENT_PLAYLIST; events_file_path: EL_FILE_PATH
		do
			across playlists as playlist loop
				if playlist.item.is_name_dated then
					events_file_path := dj_playlist_dir + playlist.item.name
					events_file_path.add_extension ("pyx")
					if not events_file_path.exists then
						create dj_playlist.make (playlist.item, dj_name, default_title)
						dj_playlist.set_output_path (events_file_path)
						dj_playlists.extend (dj_playlist)

						entries.extend (dj_playlist.new_rbox_entry)
					end
				end
			end
		end

feature -- Basic operations

	for_all_songs_id3_info (
		condition: EL_QUERY_CONDITION [RBOX_SONG]
		do_id3_edit: PROCEDURE [EL_ID3_INFO, EL_FILE_PATH]
	)
			--
		local
			song: RBOX_SONG
		do
			across songs.query (condition) as query loop
				song := query.item
				do_id3_edit (song.id3_info, song.mp3_relative_path)
			end
		end

	for_all_songs (
		condition: EL_QUERY_CONDITION [RBOX_SONG]
		do_with_song_id3: PROCEDURE [RBOX_SONG, EL_FILE_PATH, EL_ID3_INFO]
	)
			--
		local
			song: RBOX_SONG
		do
			across songs.query (condition) as query loop
				song := query.item
				do_with_song_id3 (song, song.mp3_relative_path, song.id3_info)
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
			across dj_playlists as playlist loop
				if playlist.item.is_modified then
					playlist.item.store
				end
			end
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
			not_in_any_playlist: across all_playlists as playlist all not playlist.item.has (song) end
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
				if condition.met (song) then
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

feature {RBOX_IRADIO_ENTRY, RBOX_PLAYLIST} -- Implemenation

	decoded_location (path: STRING): EL_FILE_PATH
		do
			Result := Url.remove_protocol_prefix (Url.decoded_path (path))
		end

	encoded_location_uri (uri: EL_FILE_URI_PATH): STRING
		do
			Result := Url.encoded_uri_custom (uri , Unescaped_location_characters, False)
		end

	call (obj: ANY)
		do
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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: rhythmdb
		do
			create Result.make (<<
				["@version", agent do version := node.to_real end],
				["entry[@type='song']", agent add_song_entry],
				["entry[@type='iradio']", agent do set_next_context (new_iradio_entry) end],
				["entry[@type='ignore']", agent do set_next_context (new_ignored_entry) end]
			>>)
		end

	Root_node_name: STRING = "rhythmdb"

feature {NONE} -- Constants

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
