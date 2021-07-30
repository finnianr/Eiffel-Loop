note
	description: "Rhythmbox music manager task"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-30 14:04:16 GMT (Friday 30th July 2021)"
	revision: "16"

deferred class
	RBOX_MANAGEMENT_TASK

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			element_node_type as	Attribute_node
		export
			{RBOX_MUSIC_MANAGER} make
		redefine
			make, make_default, new_instance_functions, Transient_fields, root_node_name
		end

	SONG_QUERY_CONDITIONS undefine is_equal end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	SHARED_DATABASE

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			file_path := a_file_path
			Precursor (a_file_path)
		end

	make_default
		do
			music_dir := "$HOME/Music"; music_dir.expand
			Precursor
		end

feature -- Access

	error_message: ZSTRING

	file_path: EL_FILE_PATH

	music_dir: EL_DIR_PATH
		-- root directory of mp3 files

feature -- Status query

	has_error: BOOLEAN
		do
			Result := error_message.count > 0
		end

feature -- Basic operations

	apply
		require
			no_errors: error_message.is_empty
		deferred
		end

feature -- Element change

	set_absolute_music_dir
		do
			if not music_dir.is_absolute then
				music_dir := Directory.current_working.joined_dir_path (music_dir)
			end
		end

feature {NONE} -- Implementation

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: VOLUME_INFO do create Result.make end,
				agent: PLAYLIST_EXPORT_INFO do create Result.make end,
				agent: DJ_EVENT_INFO do create Result.make end,
				agent: CORTINA_SET_INFO do create Result.make end,
				agent: DJ_EVENT_PUBLISHER_CONFIG do create Result.make end
			>>)
		end

	root_node_name: STRING
		do
			Result := Naming.class_as_snake_lower (Current, 0, tail_count)
		end

	tail_count: INTEGER
		do
			if generator.ends_with (once "_TEST_TASK") then
				Result := 2
			else
				Result := 1
			end
		end

	user_input_file_path (name: ZSTRING): EL_FILE_PATH
		do
			Result := User_input.file_path (Drag_and_drop_template #$ [name])
			lio.put_new_line
		end

feature {NONE} -- Constants

	Drag_and_drop_template: ZSTRING
		once
			Result := "Drag and drop %S here"
		end

	Transient_fields: STRING
		once
			Result := "file_path"
		end

note
	descendants: "[
			RBOX_MANAGEMENT_TASK*
				[$source COLLATE_SONGS_TASK]
				[$source PUBLISH_DJ_EVENTS_TASK]
				[$source ID3_TASK]*
					[$source ADD_ALBUM_ART_TASK]
					[$source DELETE_COMMENTS_TASK]
					[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
					[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
					[$source NORMALIZE_COMMENTS_TASK]
					[$source PRINT_COMMENTS_TASK]
					[$source REMOVE_ALL_UFIDS_TASK]
					[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
					[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
				[$source UPDATE_DJ_PLAYLISTS_TASK]
				[$source IMPORT_NEW_MP3_TASK]
				[$source DEFAULT_TASK]
				[$source ARCHIVE_SONGS_TASK]
				[$source IMPORT_VIDEOS_TASK]
				[$source REPLACE_CORTINA_SET_TASK]
				[$source REPLACE_SONGS_TASK]
				[$source RESTORE_PLAYLISTS_TASK]
				[$source EXPORT_TO_DEVICE_TASK]*
					[$source EXPORT_MUSIC_TO_DEVICE_TASK]
						[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
				[$source IMPORT_M3U_PLAYLISTS_TASK]
	]"
end