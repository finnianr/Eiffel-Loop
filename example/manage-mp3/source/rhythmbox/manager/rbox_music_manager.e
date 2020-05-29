note
	description: "Rhythmbox music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 10:51:41 GMT (Thursday 28th May 2020)"
	revision: "27"

class
	RBOX_MUSIC_MANAGER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_NAMING

	EL_MODULE_PYXIS

	EL_MODULE_USER_INPUT

	EL_MODULE_URI

	RHYTHMBOX_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_task_path: EL_FILE_PATH)
		do
			task_path := a_task_path
			create dir_path
			set_task
		end

feature -- Access

	task: RBOX_MANAGEMENT_TASK

	task_name: ZSTRING
		do
			Result := Naming.class_as_snake_lower (task, 0, 1)
			if Result.starts_with ("export") then
				Result := Name_template #$ [Result, task_path.parent.base]
			end
		end

feature -- Basic operations

	execute
			--
		do
			log.enter ("execute")
			from until user_quit loop
				if is_rhythmbox_open then
					lio.put_line ("ERROR: Rhythmbox application is open. Exit and try again.")

				elseif attached {DEFAULT_TASK} task then
					lio.put_line ("ERROR")
					lio.put_labeled_string ("Task not found", task_name)
					lio.put_new_line

				elseif task.has_error then
					lio.put_labeled_string ("ERROR", task.error_message)
					lio.put_new_line
				else
					apply_task
				end
				ask_user_for_task
			end
			log.exit
		end

feature -- Status query

	is_rhythmbox_open: BOOLEAN
		local
			rhythmbox: DETECT_RHYTHMBOX_COMMAND
		do
			create rhythmbox.make
			rhythmbox.execute
			Result := rhythmbox.is_launched
		end

	user_quit: BOOLEAN

feature {NONE} -- Implementation

	apply_task
		local
			database: RBOX_DATABASE
		do
			if not shared_database.is_created then
				create database.make (User_config_dir + "rhythmdb.xml", task.music_dir)
			end

			lio.put_labeled_string ("Executing", task_name)
			lio.put_new_line
			task.apply
		end

	ask_user_for_task
		local
			done: BOOLEAN
		do
			from until done loop
				task_path := User_input.file_path ("Drag and drop a task")
				if task_path.base ~ Quit then
					done := True; user_quit := True

				elseif task_path.exists then
					set_task
					done := True
				end
				lio.put_new_line
			end
		end

	set_task
		do
			if attached {ZSTRING} task_path.to_string as str
				and then URI.is_http (str) and then str.has_substring ("you")
			then
				create {IMPORT_YOUTUBE_M4A_TASK} task.make (str)
			else
				task := Task_factory.instance_from_pyxis (agent {RBOX_MANAGEMENT_TASK}.make (task_path))
			end
		end

	shared_database: EL_SINGLETON [RBOX_DATABASE]
		do
			create Result
		end

feature {NONE} -- Internal attributes

	dir_path: EL_DIR_PATH

	task_path: EL_FILE_PATH
		-- path to task config file

feature {MUSIC_MANAGER_SUB_APPLICATION} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S (%S)"
		end

	Quit: ZSTRING
		once
			Result := "quit"
		end

	Task_types: TUPLE [
		DEFAULT_TASK, -- Must be first

		ADD_ALBUM_ART_TASK,
		ARCHIVE_SONGS_TASK,
		COLLATE_SONGS_TASK,
		DELETE_COMMENTS_TASK,
		DISPLAY_INCOMPLETE_ID3_INFO_TASK,
		DISPLAY_MUSIC_BRAINZ_INFO_TASK,
		EXPORT_MUSIC_TO_DEVICE_TASK,
		EXPORT_PLAYLISTS_TO_DEVICE_TASK,
		IMPORT_NEW_MP3_TASK,
		IMPORT_VIDEOS_TASK,
		IMPORT_M3U_PLAYLISTS_TASK,
		LIST_VOLUMES_TASK,
		NORMALIZE_COMMENTS_TASK,
		PRINT_COMMENTS_TASK,
		PUBLISH_DJ_EVENTS_TASK,
		REMOVE_ALL_UFIDS_TASK,
		REMOVE_UNKNOWN_ALBUM_PICTURES_TASK,
		REPLACE_CORTINA_SET_TASK,
		REPLACE_SONGS_TASK,
		RESTORE_PLAYLISTS_TASK,
		UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK,
		UPDATE_DJ_PLAYLISTS_TASK
	]
		once
			create Result
		end

	Task_factory: EL_BUILDER_OBJECT_FACTORY [RBOX_MANAGEMENT_TASK]
		once
			create Result.make (agent Naming.class_as_snake_lower (?, 0, 1), Task_types)
			Result.set_make_default (agent {RBOX_MANAGEMENT_TASK}.make_default)
		end

end
