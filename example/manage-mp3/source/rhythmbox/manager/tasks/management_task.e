note
	description: "Management task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:59:53 GMT (Sunday 1st September 2019)"
	revision: "1"

deferred class
	MANAGEMENT_TASK

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{RHYTHMBOX_MUSIC_MANAGER} make
		redefine
			make, make_default, Except_fields, root_node_name
		end

	SONG_QUERY_CONDITIONS undefine is_equal end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	SHARED_DATABASE

feature {RHYTHMBOX_MUSIC_MANAGER} -- Initialization

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

	music_dir: EL_DIR_PATH
		-- root directory of mp3 files

	file_path: EL_FILE_PATH

	test_checksum: NATURAL

feature -- Status query

	is_dry_run: BOOLEAN

feature -- Basic operations

	apply
		deferred
		end

	error_check
		do
			error_message.wipe_out
		end

feature -- Element change

	set_absolute_music_dir
		do
			if not music_dir.is_absolute then
				music_dir := Directory.current_working.joined_dir_path (music_dir)
			end
		end

feature {NONE} -- Implementation

	user_input_file_path (name: ZSTRING): EL_FILE_PATH
		do
			Result := User_input.file_path (Drag_and_drop_template #$ [name])
			lio.put_new_line
		end

	register_default_values
		once
			Default_value_table.extend_from_array (<<
				create {VOLUME_INFO}.make,
				create {PLAYLIST_EXPORT_INFO}.make,
				create {DJ_EVENT_INFO}.make,
				create {CORTINA_SET_INFO}.make,
				create {DJ_EVENT_PUBLISHER_CONFIG}.make
			>>)
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 1)
		end

feature {NONE} -- Constants

	Drag_and_drop_template: ZSTRING
		once
			Result := "Drag and drop %S here"
		end

	Except_fields: STRING
		once
			Result := Precursor + ", file_path"
		end
end
