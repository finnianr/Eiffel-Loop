note
	description: "Summary description for {RBOX_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 7:55:47 GMT (Monday 22nd May 2017)"
	revision: "2"

class
	RBOX_PLAYLIST

inherit
	PLAYLIST
		rename
			make as make_playlist
		end

	MEDIA_ITEM
		rename
			relative_path as relative_m3u_path
		undefine
			is_equal, copy
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EVOLICITY_EIFFEL_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EL_MODULE_URL
		undefine
			is_equal, copy
		end

	EL_MODULE_UTF
		undefine
			is_equal, copy
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	EL_MODULE_DIGEST
		undefine
			is_equal, copy
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_database: RBOX_DATABASE)
			--
		do
			make_default
			index_by_location := a_database.songs_by_location
			index_by_audio_id := a_database.songs_by_audio_id
			silence_intervals := a_database.silence_intervals
			set_name (Empty_string)
		end

	make_default
		do
			make_playlist (10)
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

	make_with_name (a_name: like name; a_database: RBOX_DATABASE)
		do
			make (a_database)
			set_name (a_name)
		end

feature -- Access

	file_size_mb: DOUBLE
			-- Sum of size of m3u line (mega bytes) For example:

			-- #EXTINF: 182, Te Aconsejo Que me Olvides -- Aníbal Troilo (Singers: Francisco Fiorentino)
			-- /storage/sdcard1/Music/Tango/Aníbal Troilo/Te Aconsejo Que me Olvides.02.mp3
		local
			bytes: INTEGER
		do
			bytes := 8
			from start until after loop
				bytes := bytes + 22 + song.title.count + song.lead_artist.count + Root_m3u_path_count
							+ song.mp3_path.to_string.count
	 			if not song.album_artists_list.is_empty then
	 				bytes := bytes + 3 + song.album_artist.count
	 			end
				forth
			end
			Result := bytes / 1000000
		end

	checksum: NATURAL_32
			-- Media item attribute
		local
			crc: like crc_generator
		do
			crc := crc_generator
			from start until after loop
				crc.add_string (song.mp3_relative_path.to_string)
				if song.has_silence_specified then
					crc.add_integer (song.beats_per_minute)
				end
				forth
			end
			Result := crc.checksum
		end

	relative_m3u_path: EL_FILE_PATH
			-- Media item attribute
		do
			Result := Playlists_dir + name
			Result.add_extension (M3U_extension)
		end

	m3u_list: ARRAYED_LIST [RBOX_SONG]
		 -- song list with extra silence when required by songs with not enough silence
		do
			create Result.make (count)
			from start until after loop
				if not song.is_hidden then
					Result.extend (song)
					if song.has_silence_specified then
						Result.extend (song.short_silence)
					end
				end
				forth
			end
		end

	name: ZSTRING

feature -- Status query

	alternate_found: BOOLEAN

feature -- Element change

	add_song_from_audio_id (a_audio_id: EL_UUID)
		do
			log.enter_with_args ("add_song_from_audio_id", << a_audio_id >>)
			index_by_audio_id.search (a_audio_id)
			if index_by_audio_id.found then
				extend (index_by_audio_id.found_item)
				lio.put_line (last.artist + ": " + last.title)
			else
				lio.put_string_field ("Not found", a_audio_id.out)
				lio.put_new_line
			end
			log.exit
		end

	add_song_from_path (a_song_file_path: EL_FILE_PATH)
		do
			index_by_location.search (a_song_file_path)
			if index_by_location.found then
				extend (index_by_location.found_item)
			end
		end

	set_name (a_name: like name)
		do
			name := a_name
			create id.make_from_array (Digest.md5 (a_name.to_utf_8))
		end

feature {NONE} -- Implementation

	index_by_audio_id: HASH_TABLE [RBOX_SONG, EL_UUID]

	index_by_location: HASH_TABLE [RBOX_SONG, EL_FILE_PATH]

	silence_intervals: ARRAY [RBOX_SONG]

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["location/text()", agent
					do
						add_song_from_path (Url.remove_protocol_prefix (Url.decoded_path (node.to_string_8)))
					end
				],
				["audio-id/text()", agent
					do
						add_song_from_audio_id (create {EL_UUID}.make_from_string (node.to_string_8))
					end
				],
				["@name", agent do set_name (node.to_string) end]
			>>)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent: ZSTRING do Result := name end],
				["entries", agent: ITERABLE [RBOX_SONG] do Result := Current end]
			>>)
		end

feature {NONE} -- Constants

	Playlists_dir: EL_DIR_PATH
		once
			Result := "playlists"
		end

	M3U_extension: ZSTRING
		once
			Result := "m3u"
		end
end
