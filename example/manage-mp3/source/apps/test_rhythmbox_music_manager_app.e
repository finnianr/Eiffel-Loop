note
	description: "Test rhythmbox music manager app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 17:19:39 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	TEST_RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	RHYTHMBOX_MUSIC_MANAGER_APP
		rename
			initialize as normal_initialize,
			run as normal_run
		undefine
			new_log_manager, new_lio, new_log_filter_list
		redefine
			command, Option_name, Description, Log_filter
		end

	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		redefine
			Option_name, Is_test_mode, skip_normal_initialize
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

feature {NONE} -- Implementation

	skip_normal_initialize: BOOLEAN
		do

		end

feature {NONE} -- Internal attributes

	command: TEST_MUSIC_MANAGER

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Test " + Precursor
		end

	Is_test_mode: BOOLEAN = True

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := Precursor
			Result [1] := [{TEST_RHYTHMBOX_MUSIC_MANAGER_APP}, All_routines]
			Result [2] := [{TEST_MUSIC_MANAGER}, All_routines]
			Result [3] := [{RBOX_TEST_DATABASE}, All_routines]
		end

	Option_name: STRING
		once
			Result := "test_manager"
		end
end
