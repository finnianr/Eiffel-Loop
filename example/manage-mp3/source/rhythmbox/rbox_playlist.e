note
	description: "Summary description for {RBOX_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	RBOX_PLAYLIST

inherit
	ARRAYED_LIST [RBOX_SONG]
		rename
			make as make_array,
			item as song
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make as make_builder
		undefine
			is_equal, copy
		end

	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal, copy
		end

	EL_MODULE_URL
		undefine
			is_equal, copy
		end

	EL_MODULE_UTF
		undefine
			is_equal, copy
		end

	EL_MODULE_STRING
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make_with_name (a_name: like name; a_database: RBOX_DATABASE)
		do
			make (a_database)
			name := a_name
		end

	make (a_database: RBOX_DATABASE)
			--
		do
			make_array (10)
			make_builder
			make_eiffel_context
			index_by_location := a_database.songs_by_location
			index_by_track_id := a_database.songs_by_track_id
			silence_intervals := a_database.silence_intervals
			create name.make_empty
		end

feature -- Access

	name: EL_ASTRING

feature -- Basic operations

	export_as_tango_m3u (
		m3u_file_path: EL_FILE_PATH; a_device_sync_info: RBOX_SYNC_INFO_TABLE; directory_prefix: EL_DIR_PATH
		is_nokia_device: BOOLEAN
	)
		local
			m3u_file: PLAIN_TEXT_FILE
			tanda_count: INTEGER; tanda_genre: STRING
			relative_steps: EL_PATH_STEPS
			song_with_silence: ARRAYED_LIST [RBOX_SONG]
		do
			log_or_io.put_path_field ("Writing playlist", m3u_file_path); log_or_io.put_new_line
			create song_with_silence.make (2)
			create m3u_file.make_open_write (m3u_file_path.unicode)
			if not is_nokia_device then
				m3u_file.put_string ("#EXTM3U")
				m3u_file.put_new_line
			end
			from start until after loop
				song_with_silence.wipe_out
				if not song.is_hidden then
					if song.is_genre_cortina then
						tanda_count := tanda_count + 1
						if index < count then
							tanda_genre := i_th (index + 1).genre.as_upper
						else
							tanda_genre := "FINAL"
						end
						song.set_title (String.template ("Tanda $S: $S").substituted (<< tanda_count, tanda_genre >>))
					end
					song_with_silence.extend (song)
					-- Beats per minute used to indicate silence duration appended to playlist
					if silence_intervals.valid_index (song.beats_per_minute) then
						song_with_silence.extend (silence_intervals [song.beats_per_minute])
					end
					across song_with_silence as l_song loop
						relative_steps := a_device_sync_info.item (l_song.item.track_id).file_relative_path.steps
						if is_nokia_device then
							l_song.item.put_nokia_m3u_entry (m3u_file, relative_steps, directory_prefix)
						else
							l_song.item.put_m3u_entry (m3u_file, relative_steps, directory_prefix)
						end
					end
				end
				forth
			end
			m3u_file.close
		end

feature -- Status query

	alternate_found: BOOLEAN

feature -- Element change

	replace_cortinas (a_cortina_set: EL_ARRAYED_LIST [RBOX_CORTINA_SONG])
		do
			from start until after loop
				if song.is_genre_cortina then
					replace (a_cortina_set.i_th (song.track_number))
				end
				forth
			end
		end

	replace_song_with_alternate (a_song, alternate_song: RBOX_SONG)
			-- Replace song item with alternative
		do
			from start until after loop
				if song = a_song then
					replace (alternate_song)
				end
				forth
			end
		end

	add_song_from_path (a_song_file_path: EL_FILE_PATH)
		do
			index_by_location.search (a_song_file_path)
			if index_by_location.found then
				extend (index_by_location.found_item)
			end
		end

	add_song_from_track_id (a_track_id: NATURAL_64)
		do
			log.enter_with_args ("add_song_from_track_id", << a_track_id >>)
			index_by_track_id.search (a_track_id)
			if index_by_track_id.found then
				extend (index_by_track_id.found_item)
				log_or_io.put_line (last.artist + ": " + last.title)
			else
				log_or_io.put_string_field ("Not found", a_track_id.to_hex_string)
				log_or_io.put_new_line
			end
			log.exit
		end

feature {NONE} -- Implementation

	index_by_location: HASH_TABLE [RBOX_SONG, EL_FILE_PATH]

	index_by_track_id: HASH_TABLE [RBOX_SONG, NATURAL_64]

	silence_intervals: ARRAY [RBOX_SONG]

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["location/text()", agent
					do
						add_song_from_path (Url.remove_protocol_prefix (Url.unicode_decoded_path (node.to_string)))
					end
				],
				["track-id/text()", agent
					do
						add_song_from_track_id (String.hexadecimal_to_natural_64 (node.to_string))
					end
				],
				["@name", agent do name := node.to_string end]
			>>)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent: STRING do Result := name end],
				["entries", agent: ITERABLE [RBOX_SONG] do Result := Current end]
			>>)
		end

end
