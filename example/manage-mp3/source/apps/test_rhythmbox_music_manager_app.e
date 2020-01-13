note
	description: "Test rhythmbox music manager app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:32:23 GMT (Monday 13th January 2020)"
	revision: "7"

class
	TEST_RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	MUSIC_MANAGER_SUB_APPLICATION
		rename
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_log_manager, new_lio, new_log_filter_list
		redefine
			command, Option_name, Description, Log_filter
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			Visible_types, Option_name, read_command_options
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

feature {NONE} -- Internal attributes

	command: RBOX_TEST_MUSIC_MANAGER

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Test " + Precursor
		end

	Is_test_mode: BOOLEAN = True

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--

		local
			list: ARRAYED_LIST [like CLASS_ROUTINES]
		do
			create list.make_from_array (Precursor)
			across test_types as type loop
				list.extend ([type.item, All_routines])
			end
			Result := list.to_array
		end

	Option_name: STRING = "test_manager"

	Skip_normal_initialize: BOOLEAN = False

end
