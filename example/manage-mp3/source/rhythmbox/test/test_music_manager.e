note
	description: "Test music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 17:01:24 GMT (Sunday 1st September 2019)"
	revision: "7"

class
	TEST_MUSIC_MANAGER

inherit
	RHYTHMBOX_MUSIC_MANAGER
		redefine
			make, new_database, xml_data_dir,

			Task_factory, new_shared,

			-- User input
			ask_user_for_task
		end

	EL_MODULE_NAMING

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_task_path: EL_FILE_PATH)
		do
			log.enter ("test_make")
			Precursor (a_task_path)
			task.set_absolute_music_dir
			log.exit
		end

feature {NONE} -- User input

	ask_user_for_task
		do
			user_quit := True
		end

feature {NONE} -- Implementation

	new_database: RBOX_TEST_DATABASE
		do
			create Result.make (xml_file_path ("rhythmdb"), task.music_dir)
			Result.update_index_by_audio_id
		end

	new_shared: EL_SINGLETON [RBOX_TEST_DATABASE]
		do
			create Result
		end

	xml_data_dir: EL_DIR_PATH
		do
			Result := task.music_dir.parent
		end

	add_test (type: TYPE [MANAGEMENT_TASK]; factory: EL_OBJECT_FACTORY [MANAGEMENT_TASK])
		do
			factory.force (type, Naming.class_with_separator (type.name, '_', 0, 2))
		end

feature {NONE} -- Constants

	Task_factory: EL_OBJECT_FACTORY [MANAGEMENT_TASK]
		once
			Result := Precursor
			add_test ({EXPORT_MUSIC_TO_DEVICE_TEST_TASK}, Result)
			add_test ({EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK}, Result)
			add_test ({IMPORT_VIDEOS_TEST_TASK}, Result)
			add_test ({UPDATE_DJ_PLAYLISTS_TEST_TASK}, Result)
			add_test ({REPLACE_SONGS_TEST_TASK}, Result)
			add_test ({REPLACE_CORTINA_SET_TEST_TASK}, Result)
		end

end
