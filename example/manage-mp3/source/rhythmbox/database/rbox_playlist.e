note
	description: "Rhythmbox playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:00:33 GMT (Tuesday 18th March 2025)"
	revision: "38"

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
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EVC_EIFFEL_CONTEXT
		undefine
			is_equal, copy
		redefine
			make_default
		end

	M3U_PLAY_LIST_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_MODULE_DIGEST; EL_MODULE_LOG

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			make_default
			set_name (a_name)
		end

	make_default
		do
			make_playlist (10)
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVC_EIFFEL_CONTEXT}
			set_name (Empty_string)
		end

feature -- Access

	m3u_entry_list (is_windows_format, is_nokia_phone: BOOLEAN): EL_ZSTRING_LIST
		-- entry list with insert silences when song has not enough trailing silence
		local
			tanda_index: INTEGER
		do
			create Result.make (count)
			from start until after loop
				if not song.is_hidden then
					if song.is_cortina then
						tanda_index := tanda_index + 1
					end
					Result.extend (song.m3u_entry (tanda_index, is_windows_format, is_nokia_phone))
					if song.has_silence_specified then
						Result.extend (song.short_silence.m3u_entry (tanda_index, is_windows_format, is_nokia_phone))
					end
				end
				forth
			end
		end

	name: ZSTRING

	relative_m3u_path: FILE_PATH
			-- Media item attribute
		do
			Result := Playlists_dir + name
			Result.add_extension (M3U_extension)
		end

feature -- Measurement

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

	file_size_mb: DOUBLE
			-- Sum of size of m3u line (mega bytes)
		local
			bytes: INTEGER
		do
			bytes := M3U.extm3u.count + m3u_entry_list (False, False).sum_integer (agent {ZSTRING}.count)
			Result := bytes / 1000000
		end

feature -- Status query

	is_name_dated: BOOLEAN
		local
			parts: EL_SPLIT_ZSTRING_LIST
		do
			create parts.make (name, ' ')
			Result := parts.count > 1 and then parts.i_th (1).count = Date_format.count
							and then Date_checker.date_valid (parts.i_th (1), Date_format)
		end

feature -- Element change

	add_song_from_audio_id (a_audio_id: STRING)
		do
			log.enter_with_args ("add_song_from_audio_id", [a_audio_id])
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

	add_song_from_path (song_uri: EL_URI)
		do
			if index_by_location.has_key (song_uri) then
				extend (index_by_location.found_item)
			end
		end

	set_name (a_name: ZSTRING)
		do
			name := a_name
			if a_name.is_empty then
				id := Default_id
			elseif attached String_8_pool.borrowed_item as borrowed then
				set_id_from_uuid (Digest.md5 (borrowed.copied_general_as_utf_8 (a_name)).to_uuid)
				borrowed.return
			end
		end

feature {NONE} -- Implementation

	index_by_audio_id: HASH_TABLE [RBOX_SONG, STRING]
		do
			Result := Database.songs_by_audio_id
		end

	index_by_location: HASH_TABLE [RBOX_SONG, EL_URI]
		do
			Result := Database.songs_by_location
		end

	silence_intervals: ARRAY [RBOX_SONG]
		do
			Result := Database.silence_intervals
		end

feature {NONE} -- Build from XML

	add_song_from_location_node
		do
			add_song_from_path (Database.expanded_file_uri (create {EL_URI}.make (node)))
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make_assignments (<<
				["location/text()", agent add_song_from_location_node],
				["audio-id/text()", agent do add_song_from_audio_id (node.to_string_8) end],
				["@name",			  agent do set_name (node) end]
			>>)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["name",		agent: ZSTRING do Result := name end],
				["entries",	agent: ITERABLE [RBOX_SONG] do Result := Current end]
			>>)
		end

feature {NONE} -- Constants

	Date_checker: DATE_VALIDITY_CHECKER
		once
			create Result
		end

	Date_format: STRING = "yyyy-mm-dd"

	M3U_extension: ZSTRING
		once
			Result := "m3u"
		end

	Playlists_dir: DIR_PATH
		once
			Result := "playlists"
		end

end