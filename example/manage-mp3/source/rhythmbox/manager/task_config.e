note
	description: "Task config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:45:53 GMT (Saturday 31st August 2019)"
	revision: "1"

class
	TASK_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make_default
		end

	TASK_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			create selected_genres.make (10)
			task := "none"
			album_art_dir := Directory.home.joined_dir_path ("Pictures/Album Art")
			music_dir := "$HOME/Music"; music_dir.expand
			Precursor
		end

feature -- Access

	album_art_dir: EL_DIR_PATH

	archive_dir: EL_DIR_PATH
		-- directory for archived music

	cortina_set: CORTINA_SET_INFO

	dj_events: DJ_EVENT_INFO

	error_message: ZSTRING

	task: STRING

	music_dir: EL_DIR_PATH
		-- root directory of mp3 files

	playlist_export: PLAYLIST_EXPORT_INFO

	volume: VOLUME_INFO

	selected_genres: EL_ZSTRING_LIST

feature -- Status query

	is_dry_run: BOOLEAN

	is_full_export_task: BOOLEAN
		do
			Result := task ~ Task_export_music_to_device and then selected_genres.is_empty
		end

feature -- Status change

	enable_dry_run
		do
			is_dry_run := True
		end

feature -- Basic operations

	error_check
		do
			error_message.wipe_out
			if task ~ Task_replace_cortina_set then
				if cortina_set.tango_count \\ cortina_set.tangos_per_vals /= 0 then
					error_message := "tango_count must be exactly divisible by tangos_per_vals"
				end
			elseif task ~ Task_archive_songs then
				if not archive_dir.exists then
					error_message := "Use 'archive-dir' in the task configuration to specify the archive directory"
				end
			end
		end

feature -- Factory

	new_volume: EL_GVFS_VOLUME
		do
			create Result.make_with_volume (volume.name, volume.is_windows_format)
			Result.enable_path_translation
		end

feature {NONE} -- Implementation

	register_default_values
		once
			Default_value_table.extend_from_array (<<
				create {VOLUME_INFO}.make,
				create {PLAYLIST_EXPORT_INFO}.make,
				create {DJ_EVENT_INFO}.make,
				create {CORTINA_SET_INFO}.make
			>>)
		end
end
