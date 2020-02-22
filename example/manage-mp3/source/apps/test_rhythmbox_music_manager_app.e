note
	description: "Test rhythmbox music manager app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 18:17:01 GMT (Thursday 20th February 2020)"
	revision: "8"

class
	TEST_RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	MUSIC_MANAGER_SUB_APPLICATION
		rename
			log_filter as extra_log_filter,
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_log_manager, new_lio
		redefine
			command, Option_name, Description, new_log_filter_list
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			Visible_types, Option_name, read_command_options, new_log_filter_list
		redefine
			Is_test_mode, skip_normal_initialize
		select
			initialize, run
		end

feature -- Testing

	test_music_manager (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_music_manager")
			normal_run
			log.exit
		end

	test_run
			--
		do
			if not has_argument_errors then
				Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
				Test.do_file_tree_test ("rhythmdb", agent test_music_manager, command.task.test_checksum)
			end
		end

	test_types: ARRAY [TYPE [EL_MODULE_LOG]]
		do
			Result := <<
				{TEST_STORAGE_DEVICE},
				{EXPORT_MUSIC_TO_DEVICE_TEST_TASK},
				{EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK},
				{IMPORT_VIDEOS_TEST_TASK},
				{UPDATE_DJ_PLAYLISTS_TEST_TASK},
				{REPLACE_SONGS_TEST_TASK},
				{REPLACE_CORTINA_SET_TEST_TASK}
			>>
		end

feature {NONE} -- Implementation

	new_log_filter_list: EL_ARRAYED_LIST [EL_LOG_FILTER]
		local
			l_test_types: like test_types
		do
			l_test_types := test_types
			Result := Precursor {MUSIC_MANAGER_SUB_APPLICATION}
			Result.grow (Result.count + l_test_types.count)
			across l_test_types as log_type loop
				Result.extend (new_log_filter (log_type.item, All_routines))
			end
		end

feature {NONE} -- Internal attributes

	command: RBOX_TEST_MUSIC_MANAGER

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Test " + Precursor
		end

	Is_test_mode: BOOLEAN = True

	Option_name: STRING = "test_manager"

	Skip_normal_initialize: BOOLEAN = False

end
