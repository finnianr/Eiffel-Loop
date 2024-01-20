note
	description: "Reflectively buildable from pyxis"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "20"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			xml_name_space as xmlns,
			xml_naming as eiffel_naming
		export
			{NONE} all
		end

	EL_PYXIS_PARSE_EVENT_TYPE

note
	descendants: "[
			EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*
				${RBOX_MANAGEMENT_TASK}*
					${COLLATE_SONGS_TASK}
					${IMPORT_M3U_PLAYLISTS_TASK}
					${IMPORT_NEW_MP3_TASK}
					${PUBLISH_DJ_EVENTS_TASK}
					${DEFAULT_TASK}
					${UPDATE_DJ_PLAYLISTS_TASK}
					${ARCHIVE_SONGS_TASK}
					${IMPORT_VIDEOS_TASK}
						${IMPORT_VIDEOS_TEST_TASK}
						${IMPORT_YOUTUBE_M4A_TASK}
					${LIST_VOLUMES_TASK}
					${REPLACE_CORTINA_SET_TASK}
						${REPLACE_CORTINA_SET_TEST_TASK}
					${REPLACE_SONGS_TASK}
						${REPLACE_SONGS_TEST_TASK}
					${RESTORE_PLAYLISTS_TASK}
					${EXPORT_TO_DEVICE_TASK}*
						${EXPORT_MUSIC_TO_DEVICE_TASK}
							${EXPORT_PLAYLISTS_TO_DEVICE_TASK}
					${ID3_TASK}*
						${ADD_ALBUM_ART_TASK}
						${DELETE_COMMENTS_TASK}
						${DISPLAY_INCOMPLETE_ID3_INFO_TASK}
						${DISPLAY_MUSIC_BRAINZ_INFO_TASK}
						${NORMALIZE_COMMENTS_TASK}
						${PRINT_COMMENTS_TASK}
						${REMOVE_ALL_UFIDS_TASK}
						${REMOVE_UNKNOWN_ALBUM_PICTURES_TASK}
						${UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK}
	]"

end