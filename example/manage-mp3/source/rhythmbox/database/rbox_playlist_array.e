note
	description: "Rhythmbox playlist array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:54:36 GMT (Tuesday 14th February 2023)"
	revision: "19"

class
	RBOX_PLAYLIST_ARRAY

inherit
	EL_ARRAYED_LIST [RBOX_PLAYLIST]
		rename
			make as make_array
		end

	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_from_file as make
		undefine
			is_equal, copy
		redefine
			make_default, building_action_table, getter_function_table, build_from_file
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			Append as Append_mode
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make_default
		do
			make_array (7); make_machine
			create non_static_playlist_lines.make_empty
			create xml_string.make_empty
			Precursor
		end

feature -- Cursor movement

	search_by_name (playlist_name: ZSTRING)
			--
		local
			name_found: BOOLEAN
		do
			from start until name_found or after loop
				if playlist_name ~ item.name then
					name_found := True
				else
					forth
				end
			end
		end

feature -- Status query

	is_backup_mode: BOOLEAN

feature -- Basic operations

	backup
			-- Create backup using track id's instead of location
		local
			l_temp_path: FILE_PATH
		do
			l_temp_path := output_path
			output_path := output_path.with_new_extension ({STRING_32} "backup.xml")
			is_backup_mode := True
			store
			is_backup_mode := False
			output_path := l_temp_path
		end

feature -- Element change

	restore_from (other: RBOX_PLAYLIST_ARRAY)
		do
			wipe_out
			append (other)
			store
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: rhythmdb-playlists
		do
			create Result.make (<<
				["playlist[@type='static']", agent do set_collection_context (Current, create {RBOX_PLAYLIST}.make_default) end]
			>>)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["playlists", agent: ITERABLE [RBOX_PLAYLIST] do Result := Current end],
				["non_static_playlist_lines", agent: ITERABLE [ZSTRING] do Result := non_static_playlist_lines end],
				["is_backup_mode", agent: BOOLEAN_REF do Result := is_backup_mode.to_reference end]
			>>)
		end

feature {NONE} -- State line procedures

	append_playlist_lines (line: ZSTRING; a_is_static_playlist: BOOLEAN)
			--
		local
			l_line: ZSTRING
		do
			l_line := line.twin; l_line.left_adjust
			if a_is_static_playlist then
				append_to_xml (line)
			else
				non_static_playlist_lines.extend (line)
			end
			if l_line.starts_with (Playlist_end_tag) then
				state := agent find_playlist
			end
		end

	find_playlist (line: ZSTRING)
			--
		local
			l_line: ZSTRING; is_static: BOOLEAN
		do
			l_line := line.twin; l_line.left_adjust
			if l_line.starts_with (Playlist_open_tag) then
				if l_line.has_substring (Static_type_attribute) then
					static_playlist_count := static_playlist_count + 1
					is_static := True
				end
				append_playlist_lines (line, is_static)
				if not l_line.ends_with (Tag_ending) then
					state := agent append_playlist_lines (?, is_static)
				end

			elseif l_line.starts_with (Final_closing_tag) then
				append_to_xml (line)
				state := final
			else
				append_to_xml (line)
			end
		end

feature {RBOX_DATABASE} -- Implementation

	append_to_xml (a_line: ZSTRING)
		do
			xml_string.append (a_line)
			xml_string.append_character ('%N')
		end

	build_from_file (a_file_path: FILE_PATH)
		do
			if attached open_lines (a_file_path, Utf_8) as lines then
				create xml_string.make (lines.byte_count)
				do_once_with_file_lines (agent find_playlist, lines)
			end
			make_array (static_playlist_count)
			build_from_string (xml_string.to_utf_8 (True))
		end

	non_static_playlist_lines: EL_ZSTRING_LIST
		-- automatic playlists generated by Rhythmbox

	static_playlist_count: INTEGER

	xml_string: ZSTRING
		-- XML source with automatically generated playlists removed

feature {NONE} -- Type definitions

	Type_songs: INDEXABLE [FILE_PATH, INTEGER]
		do
		end

feature {NONE} -- Constants

	Final_closing_tag: ZSTRING
		once
			Result := "</rhythmdb-playlists>"
		end

	Playlist_end_tag: ZSTRING
		once
			Result := "</playlist>"
		end

	Playlist_open_tag: ZSTRING
		once
			Result := "<playlist"
		end

	Static_type_attribute: STRING = "type=%"static%">"

	Tag_ending: ZSTRING
		once
			Result := "/>"
		end

	Template: STRING_32 = "[
		<?xml version="1.0"?>
		<rhythmdb-playlists>
		#across $non_static_playlist_lines as $line loop
		$line.item
		#end
		#across $playlists as $list loop
			#if $list.item.count > 0 then	
			<playlist name="$list.item.name" type="static">
			#across $list.item.entries as $song loop
				#if $is_backup_mode then
			    <audio-id>$song.item.audio_id</audio-id>
			    #else
			    <location>$song.item.location_uri</location>
			    #end
			#end
			</playlist>
			#end
		#end
		</rhythmdb-playlists>
	]"

	XML_declaration: STRING = "<?xml version=%"1.0%"?>"

end