note
	description: "Finalized executable tasks executed by [$source RBOX_MUSIC_MANAGER] command"
	notes: "[
		Command option: `-task_autotest'
		
		**Test Sets**
		
			[$source COLLATE_SONGS_TASK_TEST_SET]
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
			[$source UPDATE_DJ_PLAYLISTS_TASK_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 17:55:33 GMT (Thursday 16th April 2020)"
	revision: "2"

class
	TASK_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			new_log_filter_list
		end

create
	make

feature {NONE} -- Implementation

	new_log_filter_list: EL_ARRAYED_LIST [EL_LOG_FILTER]
		do
			Result := Precursor + new_log_filter ({TEST_STORAGE_DEVICE}, All_routines)
		end

	test_type: TUPLE [UPDATE_DJ_PLAYLISTS_TASK_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
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
		UPDATE_DJ_PLAYLISTS_TASK_TEST_SET
	]
		do
			create Result
		end
end
