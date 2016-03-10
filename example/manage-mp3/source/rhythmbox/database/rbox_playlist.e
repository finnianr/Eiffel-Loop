note
	description: "Summary description for {RBOX_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-27 15:44:55 GMT (Sunday 27th October 2013)"
	revision: "5"

class
	RBOX_PLAYLIST

inherit
	PLAYLIST
		rename
			make as make_playlist
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

	make_default
		do
			make_playlist (10)
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

	make_with_name (a_name: like name; a_database: RBOX_DATABASE)
		do
			make (a_database)
			name := a_name
		end

	make (a_database: RBOX_DATABASE)
			--
		do
			make_default
			index_by_location := a_database.songs_by_location
			index_by_track_id := a_database.songs_by_track_id
			silence_intervals := a_database.silence_intervals
			create name.make_empty
		end

feature -- Access

	name: ASTRING

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

feature -- Status query

	alternate_found: BOOLEAN

feature -- Element change

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
