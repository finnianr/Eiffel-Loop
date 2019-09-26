note
	description: "Test music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-15 9:43:01 GMT (Sunday   15th   September   2019)"
	revision: "13"

class
	RBOX_TEST_MUSIC_MANAGER

inherit
	RBOX_MUSIC_MANAGER
		redefine
			make, Database, xml_data_dir,

			Task_factory,

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

	xml_data_dir: EL_DIR_PATH
		do
			Result := task.music_dir.parent
		end

feature {NONE} -- Constants

	Database: RBOX_TEST_DATABASE
		once
			create Result.make (xml_file_path ("rhythmdb"), task.music_dir)
			Result.update_index_by_audio_id
		end

	Testing_tasks: TUPLE [
		EXPORT_MUSIC_TO_DEVICE_TEST_TASK,
		EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK,

		IMPORT_NEW_MP3_TEST_TASK,
		IMPORT_VIDEOS_TEST_TASK,

		UPDATE_DJ_PLAYLISTS_TEST_TASK,
		REPLACE_SONGS_TEST_TASK,
		REPLACE_CORTINA_SET_TEST_TASK
	]
		once
			create Result
		end

	Task_factory: EL_BUILDER_OBJECT_FACTORY [RBOX_MANAGEMENT_TASK]
		once
			Result := Precursor
			-- ignore suffix: `_TEST_TASK'
			Result.set_type_alias (agent Naming.class_as_lower_snake (?, 0, 2))
			Result.append (Testing_tasks)
		end

end
