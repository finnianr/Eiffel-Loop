note
	description: "Reflective Eiffel object builder (from XML) context"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-30 10:40:39 GMT (Sunday 30th January 2022)"
	revision: "17"

deferred class
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		undefine
			is_equal
		redefine
			make_default
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_field_convertable_from_xml,
			export_name as xml_names,
			import_name as xml_names
		export
			{NONE} all
		redefine
			make_default, new_meta_data
		end

	EL_SETTABLE_FROM_XML_NODE
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {NONE} -- Implementation

	new_meta_data: EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA
		do
			create Result.make (Current)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := building_actions_for_type (({ANY}), element_node_field_set)
		end

	element_node_field_set: EL_FIELD_INDICES_SET
		do
			if element_node_fields = All_fields then
				create Result.make_for_any (field_table)
			else
				create Result.make_from_reflective (Current, element_node_fields)
			end
		end

	element_node_fields: STRING
		-- list of fields that will be treated as XML elements
		-- (default is element attributes)
		deferred
		ensure
			renamed_to_once_fields: Result.is_empty implies Result = Empty_set or Result = All_fields
			valid_field_names: valid_field_names (Result)
		end

note
	descendants: "[
			EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT*
				[$source RBOX_IRADIO_ENTRY]
					[$source RBOX_IGNORED_ENTRY]
						[$source RBOX_SONG]
							[$source RBOX_CORTINA_SONG]
								[$source RBOX_CORTINA_TEST_SONG]
							[$source RBOX_TEST_SONG]
								[$source RBOX_CORTINA_TEST_SONG]
						[$source RBOX_PLAYLIST_ENTRY]
				[$source CORTINA_SET_INFO]
				[$source DJ_EVENT_PUBLISHER_CONFIG]
				[$source VOLUME_INFO]
				[$source PLAYLIST_EXPORT_INFO]
				[$source DJ_EVENT_INFO]
				[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
					[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
						[$source RBOX_MANAGEMENT_TASK]*
							[$source COLLATE_SONGS_TASK]
							[$source IMPORT_M3U_PLAYLISTS_TASK]
							[$source IMPORT_NEW_MP3_TASK]
							[$source PUBLISH_DJ_EVENTS_TASK]
							[$source DEFAULT_TASK]
							[$source UPDATE_DJ_PLAYLISTS_TASK]
							[$source ARCHIVE_SONGS_TASK]
							[$source IMPORT_VIDEOS_TASK]
								[$source IMPORT_VIDEOS_TEST_TASK]
								[$source IMPORT_YOUTUBE_M4A_TASK]
							[$source LIST_VOLUMES_TASK]
							[$source REPLACE_CORTINA_SET_TASK]
								[$source REPLACE_CORTINA_SET_TEST_TASK]
							[$source REPLACE_SONGS_TASK]
								[$source REPLACE_SONGS_TEST_TASK]
							[$source RESTORE_PLAYLISTS_TASK]
							[$source EXPORT_TO_DEVICE_TASK]*
								[$source EXPORT_MUSIC_TO_DEVICE_TASK]
									[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
							[$source ID3_TASK]*
								[$source ADD_ALBUM_ART_TASK]
								[$source DELETE_COMMENTS_TASK]
								[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
								[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
								[$source NORMALIZE_COMMENTS_TASK]
								[$source PRINT_COMMENTS_TASK]
								[$source REMOVE_ALL_UFIDS_TASK]
								[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
								[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
	]"
end