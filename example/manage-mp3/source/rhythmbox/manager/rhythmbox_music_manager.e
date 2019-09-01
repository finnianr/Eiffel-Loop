note
	description: "Rhythmbox music manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 17:24:26 GMT (Sunday 1st September 2019)"
	revision: "12"

class
	RHYTHMBOX_MUSIC_MANAGER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

	SONG_QUERY_CONDITIONS

	EL_ZSTRING_CONSTANTS

	SHARED_DATABASE

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_task_path: EL_FILE_PATH)
		do
			create file_path; create dir_path
			set_task (a_task_path)
		end

feature -- Access

	task: MANAGEMENT_TASK

	task_name: ZSTRING

feature -- Basic operations

	execute
			--
		do
			log.enter ("execute")
			from until user_quit loop
				if attached {DEFAULT_TASK} task then
					lio.put_line ("ERROR")
					lio.put_labeled_string ("Task not found", task_name)
					lio.put_new_line
				else
					lio.put_labeled_string ("Task", task_name)
					lio.put_new_line
					if is_rhythmbox_open then
						lio.put_line ("ERROR: Rhythmbox application is open. Exit and try again.")
					else
						task.error_check
						if task.error_message.is_empty then
							call (new_database)
							call (Database)
							task.apply
						else
							lio.put_labeled_string ("ERROR", task.error_message)
						end
					end
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

	ask_user_for_task
		local
			task_file_path: EL_FILE_PATH; done: BOOLEAN
		do
			from until done loop
				task_file_path := User_input.file_path ("Drag and drop a task")
				if task_file_path.base ~ Quit then
					done := True; user_quit := True

				elseif task_file_path.exists then
					set_task (task_file_path)
					done := True
				end
				lio.put_new_line
			end
		end

	call (obj: ANY)
		do
		end

	new_database: RBOX_DATABASE
		do
			create Result.make (xml_file_path ("rhythmdb"), task.music_dir)
		end

	set_task (a_file_path: EL_FILE_PATH)
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE; done: BOOLEAN
		do
			create lines.make_latin (1, a_file_path)
			task_name := a_file_path.base_sans_extension
			from lines.start until done or lines.after loop
				lines.item.right_adjust
				if lines.index = 1 then
					if not lines.item.starts_with ("pyxis-doc:") then
						lio.put_line ("File is not a valid pyxis document")
						done := True
					end
				elseif lines.item.ends_with (character_string (':')) then
					task_name := lines.item
					task_name.remove_tail (1)
					done := True
				end
				lines.forth
			end
			lines.close
			if Task_factory.has_alias (task_name) then
				task := Task_factory.instance_from_alias (task_name, agent {MANAGEMENT_TASK}.make (a_file_path))
			else
				create {DEFAULT_TASK} task.make_default
			end
		end

	xml_data_dir: EL_DIR_PATH
		do
			Result := User_config_dir
		end

	xml_file_path (name: STRING): EL_FILE_PATH
		do
			Result := xml_data_dir + (name + ".xml")
		end

feature {NONE} -- Internal attributes

	dir_path: EL_DIR_PATH

	file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Task_factory: EL_OBJECT_FACTORY [MANAGEMENT_TASK]
		once
			create Result.make (1, '_', <<
				{ADD_ALBUM_ART_TASK},
				{ARCHIVE_SONGS_TASK},
				{COLLATE_SONGS_TASK},
				{DELETE_COMMENTS_TASK},
				{DISPLAY_INCOMPLETE_ID3_INFO_TASK},
				{DISPLAY_MUSIC_BRAINZ_INFO_TASK},
				{EXPORT_MUSIC_TO_DEVICE_TASK},
				{EXPORT_PLAYLISTS_TO_DEVICE_TASK},
				{IMPORT_VIDEOS_TASK},
				{NORMALIZE_COMMENTS_TASK},
				{PRINT_COMMENTS_TASK},
				{PUBLISH_DJ_EVENTS_TASK},
				{REMOVE_ALL_UFIDS_TASK},
				{REMOVE_UNKNOWN_ALBUM_PICTURES_TASK},
				{REPLACE_CORTINA_SET_TASK},
				{REPLACE_SONGS_TASK},
				{UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK},
				{UPDATE_DJ_PLAYLISTS_TASK}
			>>)
		end

	Quit: ZSTRING
		once
			Result := "quit"
		end

end
