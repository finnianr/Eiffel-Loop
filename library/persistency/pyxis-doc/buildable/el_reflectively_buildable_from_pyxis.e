note
	description: "Reflectively buildable from pyxis"
	notes: "[
		Override `new_instance_functions' to add creation functions for any attributes
		conforming to class [$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]. For example:

			new_instance_functions: ARRAY [FUNCTION [ANY]]
				do
					Result := << agent: FTP_BACKUP do create Result.make end >>
				end
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-03 15:40:38 GMT (Tuesday 3rd January 2023)"
	revision: "18"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			xml_name_space as xmlns
		undefine
			is_equal, new_building_actions, make_default
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			xml_name_space as xmlns,
			xml_naming as eiffel_naming
		export
			{NONE} all
		end

	EL_MODULE_NAMING

feature {NONE} -- Implementation

	prune_root_words_count: INTEGER
		do
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_snake_lower (Current, prune_root_words_count, 0)
		end

note
	descendants: "[
			EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*
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