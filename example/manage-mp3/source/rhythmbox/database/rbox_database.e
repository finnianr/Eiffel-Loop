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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-15 9:44:19 GMT (Friday 15th March 2024)"
	revision: "49"

class
	RBOX_DATABASE

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		undefine
			make_from_file
		redefine
			make_default, on_context_return
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			output_path as xml_database_path,
			set_output_path as set_xml_database_path,
			save_as_xml as store_as
		redefine
			make_default
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_XML_PARSE_EVENT_TYPE

	SONG_QUERY_CONDITIONS

	EL_MODULE_ARGS; EL_MODULE_LOG; EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

	EL_MODULE_OS; EL_MODULE_BUILD_INFO; EL_MODULE_ITERABLE

	RBOX_SHARED_DATABASE_FIELD_ENUM

create
	make

feature {NONE} -- Initialization

	make (a_xml_database_path: FILE_PATH; a_music_dir: like music_dir)
			--
		local
			playlist: DJ_EVENT_PLAYLIST; xml_text: STRING; entry_occurences: EL_OCCURRENCE_INTERVALS
			song_count: INTEGER
		do
			make_solitary

			if attached DB_field then
				-- Initialize once routine
			end

			music_dir := a_music_dir; music_uri := a_music_dir

			lio.put_path_field ("Reading %S", a_xml_database_path)
			lio.put_new_line

			if a_xml_database_path.exists then
				xml_text := File.plain_text (a_xml_database_path)
			else
				xml_text := Default_xml
			end
			create entry_occurences.make_by_string (xml_text, "<entry type=")
			from entry_occurences.start until entry_occurences.after loop
				if xml_text [entry_occurences.item_upper + 2] = 's' then
					song_count := song_count + 1
				end
				entry_occurences.forth
			end

		 	create entries.make (entry_occurences.count)
			create songs_by_location.make_equal (song_count)
			create songs_by_audio_id.make_equal (song_count)
			create songs.make (song_count)
		 	create silence_intervals.make_filled (new_song, 1, 3)
			create dj_playlists.make (20)

			File_system.make_directory (dj_playlist_dir)

			make_from_file (a_xml_database_path)
			build_from_string (xml_text)
			set_encoding_from_name (node_source.encoding_name)
			lio.put_new_line

			playlists_xml_path := xml_database_path.parent + "playlists.xml"
			create playlists.make (playlists_xml_path)

			-- This can only be done after all the songs have been read
			from entries.start until entries.after loop
				if attached {RBOX_IGNORED_ENTRY} entries.item as ignored and then ignored.is_playlist then
					create playlist.make_from_file (ignored.file_path)
					dj_playlists.extend (playlist)
					entries.replace (playlist.new_rbox_entry) -- replace `RBOX_IGNORED_ENTRY' with `DJ_EVENT_PLAYLIST'
				end
				entries.forth
			end
		end

	make_default
		do
			Precursor {EL_BUILDABLE_FROM_NODE_SCAN}
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
		end

feature -- Access

	all_playlists: EL_ARRAYED_LIST [PLAYLIST]
		do
			create Result.make (playlists.count + dj_playlists.count)
			Result.append (playlists)
			Result.append (dj_playlists)
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

	case_insensitive_name_clashes: LINKED_LIST [FILE_PATH]
			-- list of mp3 paths having base names that clash with another in same directory
			-- when compared without case insensitivity.
		local
			path_list: EL_SORTABLE_ARRAYED_LIST [FILE_PATH]
			name_set: EL_HASH_SET [FILE_PATH]; last_dir: DIR_PATH
		do
			create name_set.make (11); create last_dir
			create path_list.make (songs.count)
			create Result.make
			across songs as song loop
				path_list.extend (song.item.mp3_relative_path)
			end
			path_list.ascending_sort
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

	title_and_album (mp3_path: EL_URI): ZSTRING
		do
			songs_by_location.search (mp3_path)
			if songs_by_location.found then
				Result := songs_by_location.found_item.title_and_album
			else
				create Result.make_empty
			end
		end

	location_keys: ARRAYED_LIST [ZSTRING]
		local
			l_template: ZSTRING
		do
			l_template := "item [%S]: %S"
			create Result.make (songs_by_location.count)
			across songs_by_location.current_keys as key loop
				Result.extend (l_template #$ [key.cursor_index, key.item.to_file_uri_path.base])
			end
		end

feature -- Access

	dj_playlist_dir: DIR_PATH
		do
			Result := music_dir #+ "Playlists"
		end

	dj_playlists: EL_ARRAYED_LIST [DJ_EVENT_PLAYLIST]
		-- Playlists with DJ event information stored in $HOME/Music/Playlists using Pyxis format

	music_dir: DIR_PATH

	music_uri: EL_URI

	playlists: RBOX_PLAYLIST_ARRAY

	playlists_xml_path: FILE_PATH

	silence_intervals: ARRAY [RBOX_SONG]

	songs_by_audio_id: HASH_TABLE [RBOX_SONG, STRING]

	songs_by_location: HASH_TABLE [RBOX_SONG, EL_URI]

	version: REAL

feature -- Entry lists

	entries: EL_ARRAYED_LIST [RBOX_IRADIO_ENTRY]

	existing_songs: like songs.query
		do
			Result := songs.query (not song_is_hidden)
		end

	existing_songs_query (condition: EL_QUERY_CONDITION [RBOX_SONG]): like songs.query
		do
			Result := songs.query (not song_is_hidden and condition)
		end

	songs: EL_QUERYABLE_ARRAYED_LIST [RBOX_SONG]

feature -- Factory

	new_cortina (a_source_song: RBOX_SONG; a_tanda_type: ZSTRING; a_track_number, a_duration: INTEGER): RBOX_CORTINA_SONG
		do
			create Result.make (a_source_song, a_tanda_type, a_track_number, a_duration)
		end

	new_ignored_entry: RBOX_IGNORED_ENTRY
		do
			create Result.make
		end

	new_iradio_entry: RBOX_IRADIO_ENTRY
		do
			create Result.make
		end

	new_song: RBOX_SONG
		do
			create Result.make
		end

feature -- Status query

	has_song (song_path: EL_URI): BOOLEAN
		do
			Result := songs_by_location.has (song_path)
		end

	has_playlist (name: ZSTRING): BOOLEAN
		do
			Result := across all_playlists as l_playlist some
				l_playlist.item.name ~ name
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

	is_valid_genre (a_genre: ZSTRING): BOOLEAN
		do
			Result := across songs as song
				some
					song.item.genre ~ a_genre
				end
		end

feature -- Element change

	extend (a_entry: RBOX_IRADIO_ENTRY)
		do
			entries.extend (a_entry)
			if attached {RBOX_SONG} a_entry as song and then song.is_mp3_format then
				extend_with_song (song)
			end
		end

	extend_with_song (song: RBOX_SONG)
		local
			audio_id: STRING
		do
			if not song.has_audio_id then
				song.update_audio_id
			end
			songs_by_location.put (song, song.mp3_uri)
			if songs_by_location.conflict then
				lio.put_new_line
				lio.put_path_field ("DUPLICATE", song.mp3_path)
				lio.put_new_line
			else
				songs.extend (song)
				if song.has_audio_id then
					audio_id := song.audio_id
					songs_by_audio_id.put (song, audio_id)
					if songs_by_audio_id.conflict then
						lio.put_new_line
						lio.put_line ("DUPLICATES")
						lio.put_path_field ("Song 1", songs_by_audio_id.item (audio_id).mp3_path)
						lio.put_new_line
						lio.put_path_field ("Song 2", song.mp3_path)
						lio.put_new_line
					end
				else
					lio.put_new_line
					lio.put_line ("NULL AUDIO ID")
					lio.put_path_field ("Song", song.mp3_path)
					lio.put_new_line
				end
				if song.is_genre_silence and then silence_intervals.valid_index (song.duration) then
					silence_intervals [song.duration] := song
				end
			end
		end

	replace (deleted_path, replacement_path: EL_URI)
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

	replace_cortinas (a_cortina_set: CORTINA_SET)
		local
			directory_set: EL_HASH_SET [DIR_PATH]
			query_result: like songs.query
		do
			create directory_set.make (2)

			query_result := existing_songs_query (song_is_genre (Extra_genre.cortina))
			across query_result as song loop
				directory_set.put (song.item.mp3_path.parent)
			end
			delete_all (query_result)

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

	set_playlists (a_playlists: like playlists)
			--
		do
			playlists := a_playlists
		end

	set_playlists_xml_path (a_playlists_xml_path: STRING)
		do
			playlists_xml_path := a_playlists_xml_path.as_string_32
		end

	update_DJ_playlists (dj_name, default_title: ZSTRING)
			-- update DJ event playlists with any new Rhythmbox playlists
		local
			dj_playlist: DJ_EVENT_PLAYLIST; events_file_path: FILE_PATH
			p: RBOX_PLAYLIST
		do
			across playlists as playlist loop
				p := playlist.item
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

feature -- Basic operations

	for_all_songs (
		condition: EL_QUERY_CONDITION [RBOX_SONG]
		do_with_song_id3: PROCEDURE [RBOX_SONG, FILE_PATH, TL_MPEG_FILE]
	)
		-- apply `do_with_song_id3' to all existing songs meeting `condition'
		local
			song: RBOX_SONG; mp3: TL_MPEG_FILE
		do
			across existing_songs_query (condition) as query loop
				song := query.item; mp3 := song.mp3_info
				do_with_song_id3 (song, song.mp3_relative_path, mp3)
				mp3.dispose
			end
		end

	for_all_songs_id3_info (
		condition: EL_QUERY_CONDITION [RBOX_SONG]; do_id3_edit: PROCEDURE [TL_MPEG_FILE, FILE_PATH]
	)
			-- apply `do_id3_edit' to all existing songs meeting `condition'
		local
			song: RBOX_SONG; mp3: TL_MPEG_FILE
		do
			across existing_songs_query (condition) as query loop
				song := query.item; mp3 := song.mp3_info
				do_id3_edit (mp3, song.mp3_relative_path)
				mp3.dispose
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
			serialize
		end

	store_in_directory (a_dir_path: DIR_PATH)
			-- Save database and playlists in location 'a_dir_path'
		local
			l_previous_dir_path: DIR_PATH
		do
			l_previous_dir_path := xml_database_path.parent
			set_xml_database_path (a_dir_path + xml_database_path.base)
			playlists.set_output_path (a_dir_path + playlists.output_path.base)
			store_all
			set_xml_database_path (l_previous_dir_path + xml_database_path.base)
			playlists.set_output_path (l_previous_dir_path + playlists.output_path.base)
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

feature -- Removal

	delete (song: RBOX_SONG)
		do
			delete_all (<< song >>)
		end

	delete_all (a_list: ITERABLE [RBOX_SONG])
		local
			song: RBOX_SONG
		do
			across a_list as list loop
				song := list.item
				prune (song)
				OS.delete_file (song.mp3_path)
			end
		ensure
			removed_songs: old songs.count - songs.count = Iterable.count (a_list)
			removed_entries: old entries.count - entries.count = Iterable.count (a_list)
			removed_locations: old songs_by_location.count - songs_by_location.count = Iterable.count (a_list)
		end

	remove (song: RBOX_SONG)
			-- remove without deleting file
		require
			not_in_any_playlist: across all_playlists as playlist all not playlist.item.has (song) end
		do
			prune (song)
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

	shortened_file_uri (a_uri: EL_URI): EL_URI
		do
			Result := a_uri
		end

	expanded_file_uri (a_uri: EL_URI): EL_URI
		do
			Result := a_uri
		end

	prune (song: RBOX_SONG)
		do
			songs.start; songs.prune (song)
			entries.start; entries.prune (song)
			songs_by_location.remove (song.mp3_uri)
			songs_by_audio_id.remove (song.audio_id)
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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: rhythmdb
		do
			create Result.make (<<
				["@version",					agent do version := node.to_real end],
				["entry[@type='iradio']",	agent do set_next_context (new_iradio_entry) end],
				["entry[@type='ignore']",	agent do set_next_context (new_ignored_entry) end],
				["entry[@type='song']",		agent do set_next_context (new_song) end]
			>>)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			if attached {RBOX_IRADIO_ENTRY} context as entry then
				extend (entry)
				if entries.count \\ 10 = 0 or else entries.count = entries.capacity then
					lio.put_string (Read_progress_template #$ [entries.count, entries.capacity])
				end
			end
		end

feature {NONE} -- Constants

	Archive: ZSTRING
		once
			Result := "Archive"
		end

	Artists_field: ZSTRING
		once
			Result := "Artists: "
		end

	Default_xml: STRING
		once
			Result := "[
				<?xml version="1.0" standalone="yes"?>
				<rhythmdb version="1.9"/>
			]"
		end

	Read_progress_template: ZSTRING
		once
			Result := "Reading entries: [%S of %S]"
			Result.prepend_character ('%R')
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