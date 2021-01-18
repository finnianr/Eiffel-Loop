note
	description: "Finalized executable test sets"
	notes: "[
		Command option: `-rbox_autotest'
		
		**Test Sets**
		
			[$source ADD_ALBUM_ART_TASK_TEST_SET]
			[$source COLLATE_SONGS_TASK_TEST_SET]
			[$source EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET]
			[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK_TEST_SET]
			[$source IMPORT_M3U_PLAYLISTS_TASK_TEST_SET]
			[$source IMPORT_NEW_MP3_TASK_TEST_SET]
			[$source IMPORT_VIDEOS_TASK_TEST_SET]
			[$source PUBLISH_DJ_EVENTS_TASK_TEST_TASK]
			[$source REPLACE_CORTINA_SET_TASK_TEST_SET]
			[$source REPLACE_SONGS_TASK_TEST_SET]
			[$source TANGO_MP3_FILE_COLLATOR_TEST_SET]
			[$source UPDATE_DJ_PLAYLISTS_TASK_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 12:20:53 GMT (Monday 18th January 2021)"
	revision: "19"

class
	AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		ADD_ALBUM_ART_TASK_TEST_SET,
		COLLATE_SONGS_TASK_TEST_SET,
		EXPORT_MUSIC_TO_DEVICE_TASK_TEST_SET,
		EXPORT_PLAYLISTS_TO_DEVICE_TASK_TEST_SET,
		IMPORT_M3U_PLAYLISTS_TASK_TEST_SET,
		IMPORT_NEW_MP3_TASK_TEST_SET,
		IMPORT_VIDEOS_TASK_TEST_SET,
		PUBLISH_DJ_EVENTS_TASK_TEST_TASK,
		REPLACE_CORTINA_SET_TASK_TEST_SET,
		REPLACE_SONGS_TASK_TEST_SET,
		TANGO_MP3_FILE_COLLATOR_TEST_SET,
		UPDATE_DJ_PLAYLISTS_TASK_TEST_SET
	]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_GVFS_OS_COMMAND, EL_GVFS_FILE_EXISTS_COMMAND]
		do
			create Result
		end

end