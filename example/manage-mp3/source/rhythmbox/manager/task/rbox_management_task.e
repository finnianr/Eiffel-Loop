note
	description: "Rhythmbox music manager task"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-18 15:40:53 GMT (Tuesday 18th July 2023)"
	revision: "25"

deferred class
	RBOX_MANAGEMENT_TASK

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			element_node_fields as Empty_set,
			field_included as is_any_field
		export
			{RBOX_MUSIC_MANAGER} make
		redefine
			make, make_default, new_transient_fields, root_node_name
		end

	SONG_QUERY_CONDITIONS undefine is_equal end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	SHARED_DATABASE

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: FILE_PATH)
		do
			file_path := a_file_path
			Precursor (a_file_path)
		end

	make_default
		do
--			music_dir := "$HOME/Music"; music_dir.expand
			music_dir := Default_music_dir
			Precursor
		end

feature -- Access

	error_message: ZSTRING

	file_path: FILE_PATH

	music_dir: DIR_PATH
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
				music_dir := Directory.current_working #+ music_dir
			end
		end

feature {NONE} -- Implementation

	new_transient_fields: STRING
		do
			Result := Precursor + ", file_path"
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

	user_input_file_path (name: ZSTRING): FILE_PATH
		do
			Result := User_input.file_path (Drag_and_drop_template #$ [name])
			lio.put_new_line
		end

feature {NONE} -- Constants

	Default_music_dir: DIR_PATH
		-- parse output of command
		-- gsettings get org.gnome.rhythmbox.rhythmdb locations
		-- OUTPUT: ['file:///home/finnian/Music']
		local
			gsettings_cmd: EL_GET_GNOME_SETTING_COMMAND
		once
			create gsettings_cmd.make ("org.gnome.rhythmbox.rhythmdb")
			Result := gsettings_cmd.dir_uri_path ("locations").to_dir_path
		end

	Drag_and_drop_template: ZSTRING
		once
			Result := "Drag and drop %S here"
		end

note
	descendants: "[
			RBOX_MANAGEMENT_TASK*
				${COLLATE_SONGS_TASK}
				${PUBLISH_DJ_EVENTS_TASK}
				${ID3_TASK}*
					${ADD_ALBUM_ART_TASK}
					${DELETE_COMMENTS_TASK}
					${DISPLAY_INCOMPLETE_ID3_INFO_TASK}
					${DISPLAY_MUSIC_BRAINZ_INFO_TASK}
					${NORMALIZE_COMMENTS_TASK}
					${PRINT_COMMENTS_TASK}
					${REMOVE_ALL_UFIDS_TASK}
					${REMOVE_UNKNOWN_ALBUM_PICTURES_TASK}
					${UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK}
				${UPDATE_DJ_PLAYLISTS_TASK}
				${IMPORT_NEW_MP3_TASK}
				${DEFAULT_TASK}
				${ARCHIVE_SONGS_TASK}
				${IMPORT_VIDEOS_TASK}
				${REPLACE_CORTINA_SET_TASK}
				${REPLACE_SONGS_TASK}
				${RESTORE_PLAYLISTS_TASK}
				${EXPORT_TO_DEVICE_TASK}*
					${EXPORT_MUSIC_TO_DEVICE_TASK}
						${EXPORT_PLAYLISTS_TO_DEVICE_TASK}
				${IMPORT_M3U_PLAYLISTS_TASK}
	]"
end