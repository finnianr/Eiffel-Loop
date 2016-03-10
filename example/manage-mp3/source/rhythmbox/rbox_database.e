note
	description: "Summary description for {RBOX_DATABASE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	RBOX_DATABASE

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		rename
			make as make_storable,
			output_path as xml_database_path,
			set_output_path as set_xml_database_path
		redefine
			store, getter_function_table, on_context_return, utf8_encoded
		end

	MARKUP_LINE_COUNTER
		undefine
			is_equal, copy
		end

	ID3_EDITS

	RBOX_MODULE_SONG_FILTER

	MODULE_RHYTHMBOX

	EL_MODULE_ARGS

	EL_MODULE_LOG

	EL_MODULE_STRING

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_xml_database_path: EL_FILE_PATH)
			--
		do
			xml_database_path := a_xml_database_path
			playlists_xml_path := xml_database_path.parent + "playlists.xml"

		 	create entries.make (0)
			create songs_by_location.make (0)
			create songs_by_track_id.make (0)
			create songs.make (0)
			create mp3_root_location
		 	create silence_intervals.make_filled (create_song, 1, 3)

			if xml_database_path.exists and playlists_xml_path.exists then
			 	songs.grow (line_ends_with_count (xml_database_path, "type=%"song%">"))
				entries.grow (songs.capacity + 50)
				create songs_by_location.make (entries.capacity)
				create songs_by_track_id.make (entries.capacity)

				log_or_io.put_path_field ("Reading", xml_database_path)
				log_or_io.put_new_line
				make_from_file (xml_database_path)
				log_or_io.put_new_line

				create playlists.make (playlists_xml_path, Current)
				is_initialized := True
				update_mp3_root_location
			end
		end

feature -- Access

	entries: EL_ARRAYED_LIST [RBOX_IRADIO_ENTRY]

	songs: RBOX_SONG_LIST

	playlists: RBOX_PLAYLIST_ARRAY

	playlists_xml_path: EL_FILE_PATH

	mp3_root_location: EL_DIR_PATH

	mp3_root_location_steps: EL_PATH_STEPS
		do
			Result := mp3_root_location
		end

	create_song: RBOX_SONG
		do
			create Result.make (mp3_root_location)
		end

	songs_by_location: HASH_TABLE [RBOX_SONG, EL_FILE_PATH]

	songs_by_track_id: HASH_TABLE [RBOX_SONG, NATURAL_64]

	silence_intervals: ARRAY [RBOX_SONG]

	title_and_album (mp3_path: EL_FILE_PATH): EL_ASTRING
		do
			songs_by_location.search (mp3_path)
			if songs_by_location.found then
				Result := songs_by_location.found_item.title_and_album
			else
				create Result.make_empty
			end
		end

	actions: EL_ASTRING_HASH_TABLE [PROCEDURE [RBOX_DATABASE, TUPLE]]
		do
			create Result.make (<<
				["print_comments", 								agent print_comments],
				["delete_comments", 								agent delete_comments],
				["remove_all_ufids", 							agent remove_all_ufids],
				["update_comments_with_album_artists", 	agent update_comments_with_album_artists],
				["normalize_comments", 							agent normalize_comments],
				["rewrite_incomplete_id3_info",				agent rewrite_incomplete_id3_info],
				["remove_unknown_album_pictures", 			agent remove_unknown_album_pictures]
			>>)
		end

feature -- Status query

	is_initialized: BOOLEAN

	has_song (song_path: EL_FILE_PATH): BOOLEAN
		do
			Result := songs_by_location.has (song_path)
		end

	is_valid_genre (a_genre: EL_ASTRING): BOOLEAN
		do
			Result := across songs as song
				some
					song.item.genre ~ a_genre
				end
		end

	utf8_encoded: BOOLEAN
		do
			Result := True
		end

feature -- Element change

	extend (a_entry: RBOX_IRADIO_ENTRY)
			--
		local
			track_id: NATURAL_64
		do
			entries.extend (a_entry)
			if attached {RBOX_SONG} a_entry as song then
				songs_by_location.put (song, song.mp3_path)
				if songs_by_location.conflict then
					log_or_io.put_new_line
					log_or_io.put_path_field ("DUPLICATE", song.mp3_path)
					log_or_io.put_new_line
				else
					songs.extend (song)
					track_id := song.track_id
					if track_id > 0 then
						songs_by_track_id.put (song, track_id)
						if songs_by_track_id.conflict then
							log_or_io.put_new_line
							log_or_io.put_line ("DUPLICATES")
							log_or_io.put_path_field ("Song 1", songs_by_track_id.item (track_id).mp3_path)
							log_or_io.put_new_line
							log_or_io.put_path_field ("Song 2", song.mp3_path)
							log_or_io.put_new_line
						end
					end
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

	replace_cortinas (a_cortina_set: EL_ARRAYED_LIST [RBOX_CORTINA_SONG])
		local
			directory_set: EL_HASH_SET [EL_DIR_PATH]
		do
			create directory_set.make_equal (2)
			from songs.start until songs.after loop
				if not songs.item.is_hidden
					and then Song_filter.is_of_genre (songs.item, Rhythmbox.Genre_cortina)
				then
					File_system.delete (songs.item.mp3_path)
					directory_set.put (songs.item.mp3_path.parent)
					remove (songs.item)
					songs.remove
				else
					songs.forth
				end
			end
			across directory_set as cortina_dir loop
				File_system.delete_if_empty (cortina_dir.item)
			end
			across a_cortina_set as cortina loop
				extend (cortina.item)
			end
			playlists.do_all (agent {RBOX_PLAYLIST}.replace_cortinas (a_cortina_set))
		end

	delete_and_replace (deleted_path, substitute_path: EL_FILE_PATH)
		local
			deleted_song, alternate_song: RBOX_SONG
			deleted_song_index: INTEGER
		do
			songs.find_first (deleted_path, agent {RBOX_SONG}.mp3_path)
			if not songs.exhausted then
				deleted_song := songs.item
				deleted_song_index := songs.index
				songs.find_first (substitute_path, agent {RBOX_SONG}.mp3_path)
				if not songs.exhausted then
					alternate_song := songs.item
					remove (deleted_song)
					songs.go_i_th (deleted_song_index)
					songs.remove
					log_or_io.put_string_field ("Replaced", deleted_song.title_and_album.to_utf8)
					log_or_io.put_new_line

					playlists.do_all (agent {RBOX_PLAYLIST}.replace_song_with_alternate (deleted_song, alternate_song))
				end
			end
			File_system.delete (deleted_path)
		end

	update_index_by_track_id
		do
			songs_by_track_id.wipe_out
			songs.set_default_criteria
			across songs.query_results as song loop
				songs_by_track_id.search (song.item.track_id)
				if not songs_by_track_id.found then
					songs_by_track_id.extend (song.item, song.item.track_id)
				else
					check
						track_ids_are_unique: False
					end
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
			l_song: RBOX_SONG
		do
			log.enter_with_args ("import_mp3", << mp3_path >>)
			relative_path_steps := mp3_path.relative_path (mp3_root_location).steps
			if relative_path_steps.count = 3 then
				create id3_info.make (mp3_path)
				l_song := create_song
				if id3_info.title.is_empty then
					l_song.set_title (mp3_path.without_extension.base)
				else
					l_song.set_title (id3_info.title)
				end
				l_song.set_album (id3_info.album)
				l_song.set_track_number (id3_info.track)
				l_song.set_recording_year (id3_info.year)

				l_song.set_genre (relative_path_steps.i_th (1))
				l_song.set_artist (relative_path_steps.i_th (2))

				l_song.write_id3_info (id3_info)
				l_song.set_mp3_path (l_song.unique_normalized_mp3_path)
				File_system.move (mp3_path, l_song.mp3_path)

				extend (l_song)
				log_or_io.put_path_field ("Imported", l_song.mp3_relative_path_steps.as_file_path)
				log_or_io.put_new_line
			end
			log.exit
		end

feature -- Basic operations

	import_m3u_playlist (m3u_playlist: M3U_PLAYLIST)
		do
			log_or_io.put_string_field ("Importing playlist", m3u_playlist.name)
			log_or_io.put_new_line
			playlists.extend (create_playlist (m3u_playlist.name))
			m3u_playlist.do_all (
				agent (path_steps: EL_PATH_STEPS)
					local
						song_path: EL_FILE_PATH
					do
						song_path := mp3_root_location.joined_file_steps (path_steps)
						if has_song (song_path) then
							playlists.last.add_song_from_path (song_path)
							log_or_io.put_path_field ("Imported", song_path)
						else
							log_or_io.put_path_field ("Not found", song_path)
						end
						log_or_io.put_new_line
					end
			)
			log_or_io.put_new_line
		end

	update_mp3_root_location
			--
		require
			valid_database: is_initialized
		do
			create longest_common_directory
			songs.set_default_criteria
			songs.query_results.do_all (agent set_longest_common_directory)
			mp3_root_location.share (longest_common_directory)
		end

	collate_songs (a_dry_run_output_dir: EL_DIR_PATH)
		local
			is_dry_run: BOOLEAN; new_mp3_path: EL_FILE_PATH; l_song: RBOX_SONG
			device: MP3_DEVICE; playlist_track_id_set: DS_HASH_SET [NATURAL_64]
		do
			log.enter ("collate_songs")
			is_dry_run := not a_dry_run_output_dir.is_empty
			create playlist_track_id_set.make_default
			playlist_track_id_set.wipe_out
			songs.set_default_criteria
			songs.add_negative_criteria (agent {RBOX_SONG}.is_mp3_path_normalized)
			across songs.query_results as song loop
				l_song := song.item
				new_mp3_path := l_song.unique_normalized_mp3_path
				log_or_io.put_string_field ("Collating", l_song.title)
				log_or_io.put_new_line
				if is_dry_run then
					playlist_track_id_set.force (l_song.track_id)
				else
					File_system.make_directory (new_mp3_path.parent)
					File_system.move (l_song.mp3_path, new_mp3_path)
					if l_song.mp3_path.parent.exists then
						File_system.delete_empty_steps (l_song.mp3_path.parent.steps)
					end
					songs_by_location.replace_key (new_mp3_path, l_song.mp3_path)
					l_song.set_mp3_path (new_mp3_path)
				end
			end
			if is_dry_run then
				create device.make (a_dry_run_output_dir, Current, 0)
				device.set_criteria (agent Song_filter.is_in_track_id_set (?, playlist_track_id_set))
				device.export_songs
			else
				store
			end
			log.exit
		end

	restore_playlists
			-- restore playlists from playlists.backup.xml
		local
			backup_path: EL_FILE_PATH
		do
			backup_path := playlists_xml_path.with_new_extension ("backup.xml")
			if backup_path.exists then
				log_or_io.put_path_field ("Restoring playlists from", backup_path); log_or_io.put_new_line

				create playlists.make (backup_path, Current)
				File_system.delete (playlists_xml_path)
				playlists.set_output_path (playlists_xml_path)
				playlists.store
  			else
				log_or_io.put_path_field ("File not found", backup_path); log_or_io.put_new_line
			end
		end

	store
			--
		do
			log.put_line ("Saving entries")
			Precursor
			log.put_line ("Saving playlists")
			playlists.store
		end

	store_in_directory (a_dir_path: EL_DIR_PATH)
			-- Save database and playlists in location 'a_dir_path'
		local
			l_previous_dir_path: EL_DIR_PATH
		do
			l_previous_dir_path := xml_database_path.parent
			set_xml_database_path (a_dir_path + xml_database_path.base)
			playlists.set_output_path (a_dir_path + playlists.output_path.base)
			store
			set_xml_database_path (l_previous_dir_path + xml_database_path.base)
			playlists.set_output_path (l_previous_dir_path + playlists.output_path.base)
		end

feature -- Tag editing

	add_album_pictures (album_art_dir: EL_DIR_PATH)
		local
			pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
			picture: EL_ID3_ALBUM_PICTURE
			jpeg_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("add_album_pictures")
			jpeg_path_list := File_system.file_list (album_art_dir, "*.jpeg")
			create pictures.make_equal (jpeg_path_list.count)
			across jpeg_path_list as jpeg_path loop
				create picture.make_from_file (jpeg_path.item, jpeg_path.item.parent.steps.last)
				pictures [jpeg_path.item.without_extension.base] := picture
			end

			songs.set_criteria_with_default (agent Song_filter.has_artist_or_album_picture (?, pictures))
			do_across_songs (agent add_song_picture (?, ?, ?, pictures), False)
			log.exit
		end

	print_comments
		do
			log.enter ("print_comments")
			songs.set_default_criteria
			do_across_id3 (agent print_id3_comments, True)
			log.exit
		end

	delete_comments
			-- Delete comments except 'c0'
		do
			log.enter ("delete_comments")
			songs.set_default_criteria
			do_across_id3 (agent delete_id3_comments, False)
			log.exit
		end

	normalize_comments
			-- Rename 'Comment' comments as 'c0'
			-- This is an antidote to a bug in Rhythmbox version 2.97 where editions to
			-- 'c0' command are saved as 'Comment' and are no longer visible on reload.
		do
			log.enter ("delete_comments")
			songs.set_default_criteria
			do_across_id3 (agent normalize_comment, False)
			log.exit
		end

	remove_all_ufids
			--
		do
			log.enter ("remove_all_ufids")
			songs.set_default_criteria
			do_across_songs (agent remove_ufid, False)
			log.exit
		end

	update_comments_with_album_artists
			--
		do
			log.enter ("update_comments_with_album_artists")
			songs.set_default_criteria
			do_across_songs (agent update_song_comment_with_album_artists, False)
			log.exit
		end

	rewrite_incomplete_id3_info
		do
			log.enter ("rewrite_incomplete_id3_info")
			songs.set_default_criteria
			do_across_songs (agent rewrite_id3_info, True)
			log.exit
		end

	remove_unknown_album_pictures
		do
			log.enter ("remove_unknown_album_pictures")
			songs.set_criteria_with_default (
				agent (song: RBOX_SONG): BOOLEAN
					do
						Result := song.artist /~ Unknown and then song.album ~ Unknown
					end
			)
			do_across_songs (agent remove_unknown_album_picture, False)
			log.exit
		end

feature {NONE} -- Tag editing

	add_song_picture (
		song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO
		pictures: EL_ASTRING_HASH_TABLE [EL_ID3_ALBUM_PICTURE]
	)
		local
			picture: EL_ID3_ALBUM_PICTURE
		do
			if Song_filter.has_artist_picture (song, pictures) and then not id3_info.has_album_picture then
				picture := pictures [song.artist]

			elseif Song_filter.has_album_picture (song, pictures) and then song.album /~ Unknown then
				picture := pictures [song.album]

			else
				create picture
			end
			if picture.data.count > 0 and then picture.checksum /= song.album_picture_checksum then
				log_or_io.put_labeled_string ("Setting", picture.description.as_proper_case + " picture")
				log_or_io.put_new_line
				log_or_io.put_path_field ("Song", relative_song_path)
				log_or_io.put_new_line
				log_or_io.put_new_line

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
				print_id3 (relative_song_path, id3_info)
				id3_info.remove_all_unique_ids
				id3_info.update
			end
		end

	update_song_comment_with_album_artists (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			--
		local
			l_album_artists: EL_ASTRING
		do
			l_album_artists := song.album_artists

			-- Due to a bug in Rhythmbox, it is not possible to set album-artist to zero length
			-- As a workaround, setting album-artist to '--' will cause it to be deleted

			if song.album_artists_list.count = 1 and song.album_artists_list.first ~ song.artist
				or else song.album_artists.is_equal ("--")
			then
				song.set_album_artists_list ("")
				id3_info.remove_basic_field (Tag.Album_artist)
				l_album_artists := song.album_artists
			end
			if l_album_artists /~ id3_info.comment (ID3_frame_c0) then
				print_id3 (relative_song_path, id3_info)
				log_or_io.put_string_field ("Album artists", l_album_artists)
				log_or_io.put_new_line
				log_or_io.put_string_field (ID3_frame_c0, id3_info.comment (ID3_frame_c0))
				log_or_io.put_new_line
				if l_album_artists.is_empty then
					id3_info.remove_comment (ID3_frame_c0)
				else
					id3_info.set_comment (ID3_frame_c0, l_album_artists)
				end
				id3_info.update
			end
		end

	rewrite_id3_info (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		do
			if across id3_info.user_text_table as user_text
				some
					user_text.item.description.is_empty and then user_text.item.string.is_integer
				end
			then
				print_id3 (relative_song_path, id3_info)
			end
		end

	remove_unknown_album_picture (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
		do
			if id3_info.has_album_picture and then id3_info.album_picture.description ~ Rhythmbox.Picture_artist then
				id3_info.remove_album_picture
				Musicbrainz_album_id_set.do_all (agent id3_info.remove_user_text)
				id3_info.update
				song.set_album_picture_checksum (0)
				log_or_io.put_path_field ("Removed album picture", relative_song_path)
				log_or_io.put_new_line
			end
		end

feature -- Removal

	wipe_out
			--
		do
			entries.wipe_out
			songs.wipe_out
			songs_by_location.wipe_out
			songs_by_track_id.wipe_out
		end

	remove_all_mp3
			--
		do
			across songs as song loop
				remove (song.item)
			end
			songs.wipe_out
		end

	remove (a_entry: RBOX_IRADIO_ENTRY)
		do
			songs_by_location.remove (a_entry.location)
			if attached {RBOX_SONG} a_entry as l_song then
				songs_by_track_id.remove (l_song.track_id)
			end
			entries.search (a_entry)
			if entries.exhausted then
				entries.find_first (a_entry.location, agent {RBOX_IRADIO_ENTRY}.location)
			end
			if not entries.exhausted then
				entries.remove
			end
		ensure
			entry_removed: entries.count = old entries.count - 1
		end

feature {NONE} -- Implementation

	do_across_id3 (action: PROCEDURE [like Current, TUPLE [EL_FILE_PATH, EL_ID3_INFO]]; readonly: BOOLEAN)
			--
		do
			across songs.query_results as song loop
				action.call ([song.item.mp3_relative_path_steps.as_file_path, song.item.id3_info])
			end
			if not readonly then
				store
			end
		end

	do_across_songs (action: PROCEDURE [like Current, TUPLE [RBOX_SONG, EL_FILE_PATH, EL_ID3_INFO]]; readonly: BOOLEAN)
			--
		do
			across songs.query_results as song loop
				action.call ([song.item, song.item.mp3_relative_path_steps.as_file_path, song.item.id3_info])
			end
			if not readonly then
				store
			end
		end

	create_playlist (a_name: STRING): RBOX_PLAYLIST
		do
			create Result.make_with_name (a_name, Current)
		end

	set_longest_common_directory (song: RBOX_SONG)
			--
		do
			if longest_common_directory.is_empty then
				longest_common_directory.append (song.mp3_path.parent.steps)

			else
				from until
					song.mp3_path.parent.steps.starts_with (longest_common_directory)
				loop
					longest_common_directory.finish
					longest_common_directory.remove
				end
			end
		end

feature {NONE} -- Internal attributes

	longest_common_directory: EL_PATH_STEPS

feature {NONE} -- Evolicity relfection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["entries", agent: ITERABLE [RBOX_IRADIO_ENTRY] do Result := entries end]
			>>)
		end

feature {NONE} -- Build from XML

	add_song_entry
			--
		do
			if songs.count \\ 10 = 0 or else songs.count = songs.capacity then
				io.put_string (Read_progress_template.substituted (<< songs.count, songs.capacity >>))
			end
			set_next_context (create_song)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			if attached {RBOX_IRADIO_ENTRY} context as entry then
				extend (entry)
				if attached {RBOX_SONG} entry as song
					and then song.is_genre_silence
				then
					if silence_intervals.valid_index (song.duration) then
						silence_intervals [song.duration] := song
					end
				end
			end
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: rhythmdb
		do
			create Result.make (<<
				["entry[@type='song']", agent add_song_entry],
				["entry[@type='iradio']", agent do set_next_context (create {RBOX_IRADIO_ENTRY}.make) end],
				["entry[@type='ignore']", agent do set_next_context (create {RBOX_IGNORED_ENTRY}.make) end]
			>>)
		end

	Root_node_name: STRING = "rhythmdb"

feature {NONE} -- Constants

	Musicbrainz_album_id_set: ARRAY [EL_ASTRING]
			-- Both fields need to be set in ID3 info otherwise
			-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
		once
			Result := << "MusicBrainz Album Id", "musicbrainz_albumid" >>
		end

	Read_progress_template: EL_TEMPLATE_STRING
		once
			Result := String.template ("%RSongs: [$S of $S]")
		end

	Artists_field: EL_ASTRING
		once
			Result := "Artists: "
		end

	Unknown_artist_names: ARRAY [EL_ASTRING]
		once
			Result := << "Various", "Various Artists", "Unknown" >>
			Result.compare_objects
		end

	Unknown: EL_ASTRING
		once
			Result := "Unknown"
		end

	Template: STRING =
		-- Substitution template

	"[
		<?xml version="1.0" standalone="yes"?>
		<rhythmdb version="1.8">
		#across $entries as $entry loop
			#evaluate ($entry.item.template_name, $entry.item)
		#end
		</rhythmdb>
	]"

end
