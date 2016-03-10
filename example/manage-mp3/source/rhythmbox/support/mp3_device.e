note
	description: "Device to which to mp3 files can be exported"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MP3_DEVICE

inherit
	MODULE_RHYTHMBOX

	RBOX_MODULE_SONG_FILTER

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_export_path: like export_path; a_database: like database; a_id3_version: like id3_version)
		require
			valid_version: ID3.Valid_ID3_versions.has (a_id3_version)
		do
			log.enter_with_args ("make", << a_export_path >>)
			export_path := a_export_path; database := a_database; id3_version := a_id3_version
			create sync_info.make_from_file (export_path + Rhythmbox.Sync_info_name)
			criteria := agent Song_filter.is_any
			log.exit
		end

feature -- Access

	export_path: EL_DIR_PATH

	id3_version: REAL
		-- id3 version to export

feature -- Element change

	set_criteria (a_criteria: like criteria)
		do
			criteria := a_criteria
		end

feature -- Basic operations

	export_songs
		local
			progress_info: EL_QUANTITY_PROGRESS_INFO
			megabytes: DOUBLE
			exportable_songs, new_songs, updated_songs: ARRAYED_LIST [RBOX_SONG]
			l_songs_to_delete: like songs_to_delete
		do
			log.enter ("export_songs")

			File_system.make_directory (export_path)
			File_system.make_directory (Temporary_dir)

			songs.set_criteria_with_default (criteria)
			songs.add_criteria (agent Song_filter.is_updated_export (?, sync_info))
			updated_songs := songs.query_results

			songs.set_criteria_with_default (criteria)
			songs.add_criteria (agent Song_filter.is_new_export (?, sync_info))
			new_songs := songs.query_results

			l_songs_to_delete := songs_to_delete
			across updated_songs as song loop
				l_songs_to_delete.extend (song.item.track_id)
			end
			delete (l_songs_to_delete)

			exportable_songs := updated_songs
			exportable_songs.append (new_songs)

			across exportable_songs as song loop
				 megabytes := megabytes + File_system.file_megabyte_count (song.item.mp3_path)
			end
			create progress_info.make (megabytes, 1, "mb")
			if log.current_routine_is_active then
				progress_info.enable_line_advance
			end

			if not exportable_songs.is_empty then
				log_or_io.put_line ("Exporting songs")
			end

			across exportable_songs as song loop
				progress_info.increment (File_system.file_megabyte_count (song.item.mp3_path))
				log_or_io.put_string (progress_info.last_string)
				log_or_io.put_path_field (" Copying", song.item.mp3_relative_path_steps.as_file_path)
				log_or_io.put_new_line

				export_song (song.item)
			end
			log.put_new_line

			File_system.delete_if_empty (Temporary_dir)

			log.put_line ("Saving sync info")
			sync_info.store
			if is_full_export then
				database.store_in_directory (export_path)
			end
			log.exit
		end

	export_playlists (a_playlist_info: like Type_export_parameters)
		local
			playlist_track_id_set: DS_HASH_SET [NATURAL_64]
		do
			log.enter_with_args ("export_playlists", << export_path >>)
			create playlist_track_id_set.make_default

			across playlists as playlist loop
				across playlist.item as song loop
					if not song.item.is_hidden then
						playlist_track_id_set.force (song.item.track_id)
					end
				end
			end
			across database.silence_intervals as silence loop
				playlist_track_id_set.force (silence.item.track_id)
			end
			criteria := agent Song_filter.is_in_track_id_set (?, playlist_track_id_set)
			export_songs
			playlists.do_all (agent write_m3u_playlist (?, a_playlist_info))
			log.exit
		end

feature -- Status query

	is_full_export: BOOLEAN
			-- Only hidden songs are filtered
		do
			Result := songs.positive_critera_count = 1
		end

feature {NONE} -- Implementation

	export_song (song: like songs.item)
		local
			source_file_path, destination_file_path, temp_file_path: EL_FILE_PATH
			id3_info: EL_ID3_INFO
		do
			source_file_path := song.mp3_path
			destination_file_path :=  exported_song_path (song)

			File_system.make_directory (destination_file_path.parent)

			temp_file_path := Temporary_dir + source_file_path.base
			File_system.copy (source_file_path, temp_file_path)

			create id3_info.make (temp_file_path)
			id3_info.set_encoding ("UTF-8")

			apply_device_specific_tag_edit (export_path.steps [3], id3_info)
			id3_info.set_version (id3_version)
			id3_info.update

			File_system.move (temp_file_path, destination_file_path)

			sync_info [song.track_id] := create {RBOX_SYNC_INFO}.make (
				song.track_id, song.last_checksum, exported_song_relative_path (song)
			)
		end

	exported_song_path (song: like songs.item): EL_FILE_PATH
		do
			Result :=  export_path + exported_song_relative_path (song)
		end

	exported_song_relative_path (song: like songs.item): EL_FILE_PATH
		do
			Result := song.exportable_mp3_path.relative_path (database.mp3_root_location)
		end

	delete (song_ids: like songs_to_delete)
		local
			device_song_path: EL_FILE_PATH
		do
			if not song_ids.is_empty then
				across song_ids as track_id loop
					device_song_path := sync_info.item_path (export_path, track_id.item)
					log_or_io.put_path_field ("Deleting", device_song_path)
					log_or_io.put_new_line
					File_system.delete (device_song_path)
					File_system.delete_if_empty (device_song_path.parent)
					sync_info.remove (track_id.item)
				end
				log_or_io.put_new_line
			end
		end

	songs_to_delete: ARRAYED_LIST [NATURAL_64]
			-- track ids of songs deleted since last export
		do
			create Result.make (10)
			across sync_info.current_keys as track_id loop
				songs_by_track_id.search (track_id.item)
				if not songs_by_track_id.found or else songs_by_track_id.found_item.is_hidden then
					Result.extend (track_id.item)
				end
			end
		end

	write_m3u_playlist (playlist: RBOX_PLAYLIST; a_playlist_info: like Type_export_parameters)
			--
		local
			m3u_file_path: EL_FILE_PATH
		do
			if a_playlist_info.playlist_subdirectory.is_empty then
				m3u_file_path := export_path + playlist.name
			else
				m3u_file_path := export_path.joined_file_steps (<<
					a_playlist_info.playlist_subdirectory, playlist.name
				>>)
			end
			m3u_file_path.add_extension (a_playlist_info.m3u_extension)
			File_system.make_directory (m3u_file_path.parent)
			playlist.export_as_tango_m3u (m3u_file_path, sync_info, a_playlist_info.directory_prefix, a_playlist_info.is_nokia_device)
		end

	apply_device_specific_tag_edit (device_id: EL_ASTRING; id3_info: EL_ID3_INFO)
		do
--			log.enter_with_args ("apply_device_specific_tag_edit", << device_id.to_string_8 >>)
			device_specific_tag_edits.search (device_id)
			if device_specific_tag_edits.found then
--				log.put_string_field ("Found", device_id); log.put_new_line
				device_specific_tag_edits.found_item.call ([id3_info])
				id3_info.update
			end
--			log.exit
		end

	songs: like database.songs
		do
			Result := database.songs
		end

	songs_by_track_id: like database.songs_by_track_id
		do
			Result := database.songs_by_track_id
		end

	playlists: like database.playlists
		do
			Result := database.playlists
		end

	criteria: PREDICATE [ANY, TUPLE [RBOX_SONG]]
		-- export criteria

	sync_info: RBOX_SYNC_INFO_TABLE

	database: RBOX_DATABASE

feature -- Type definitions

	Type_export_parameters: TUPLE [directory_prefix, m3u_extension, playlist_subdirectory: EL_ASTRING; is_nokia_device: BOOLEAN]
		once
		end

feature {NONE} -- Constants

	Temporary_dir: EL_DIR_PATH
		once
			Result := Directory.Temporary.joined_dir_path ("rhythmbox")
		end

	Device_specific_tag_edits: EL_ASTRING_HASH_TABLE [PROCEDURE [ANY, TUPLE [EL_ID3_INFO]]]
		-- Device specific adjustments to tags on export
		once
			create Result
			Result ["GT-N5110"] := agent (a_id3_info: EL_ID3_INFO)
					-- Samsung Galaxy Note Music Player displays genre "Tango" as "Latin"
					-- which is annoying
				do
					if a_id3_info.genre ~ Rhythmbox.Genre_tango then
						a_id3_info.set_genre ("Tango (Classical)")
					end
				end

			Result ["Music-new"] := agent (a_id3_info: EL_ID3_INFO)
					-- Test case
				do
					if a_id3_info.genre ~ Rhythmbox.Genre_tango then
						a_id3_info.set_genre ("Tango (Classical)")
					end
				end

		end

	ID3: EL_ID3_ENCODINGS
		once
			create Result
		end

end
