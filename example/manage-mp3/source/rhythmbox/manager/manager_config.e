note
	description: "Summary description for {DATABASE_EXPORT_CONFIG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:26:06 GMT (Wednesday 16th December 2015)"
	revision: "4"

class
	MANAGER_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_default as make
		redefine
			make, building_action_table
		end

	EL_MODULE_DIRECTORY

	TASK_CONSTANTS

create
	make, make_from_file

feature {NONE} -- Initialization

	make
		do
			task := "none"
			create volume
			volume.name := "."
			volume.type := Empty_string
			volume.destination_dir := create {EL_DIR_PATH}
			volume.is_windows_format := True
			volume.id3_version := 2.3

			create dj_events
			dj_events.playlist_dir := Directory.home.joined_dir_path ("Documents/DJ-events")
			dj_events.dj_name := "Unknown"
			dj_events.default_title := ""
			dj_events.publisher := create {DJ_EVENT_PUBLISHER_CONFIG}.make

			album_art_dir := Directory.home.joined_dir_path ("Pictures/Album Art")
			extra_music_dir := Directory.home.joined_dir_path ("Music Extra")
			create selected_genres.make (10); selected_genres.compare_objects

			playlist_export := [Empty_string, Default_playlists_subdirectory_name, Default_m3u_extension]

			create cortina_set
			cortina_set.fade_in_duration := 3.0
			cortina_set.fade_out_duration := 3.0
			cortina_set.clip_duration := 25
			cortina_set.tango_count := 8
			cortina_set.tangos_per_vals := 4

			create error_message.make_empty
			Precursor
		end

feature -- Factory

	new_volume: EL_GVFS_VOLUME
		do
			create Result.make_with_volume (volume.name, volume.is_windows_format)
			Result.enable_path_translation
		end

feature -- Attributes access

	album_art_dir: EL_DIR_PATH

	cortina_set: TUPLE [fade_in_duration, fade_out_duration: REAL; clip_duration, tango_count, tangos_per_vals: INTEGER]

	dj_events: TUPLE [playlist_dir: EL_DIR_PATH; dj_name, default_title: ZSTRING; publisher: DJ_EVENT_PUBLISHER_CONFIG]

	error_message: ZSTRING

	extra_music_dir: EL_DIR_PATH

	playlist_export: TUPLE [root, subdirectory_name, m3u_extension: ZSTRING]

	selected_genres: ARRAYED_LIST [ZSTRING]

	task: STRING

	test_checksum: NATURAL

	volume: TUPLE [name, type: ZSTRING; destination_dir: EL_DIR_PATH; is_windows_format: BOOLEAN; id3_version: REAL]

feature -- Basic operations

	error_check
		do
			error_message.wipe_out
			if playlist_changing_tasks.has (task) then
				if not dj_events.playlist_dir.exists then
					error_message := "Cannot find directory: DJ-events/playlist_dir"
				end
			elseif task ~ Task_replace_cortina_set then
				if cortina_set.tango_count \\ cortina_set.tangos_per_vals /= 0 then
					error_message := "tango_count must be exactly divisible by tangos_per_vals"
				end
			elseif task ~ Task_relocate_songs then
				if not extra_music_dir.exists then
					error_message := "Cannot find directory: extra_music_location"
				end
			end
		end

feature -- Element change

	set_volume_destination_dir (a_volume_destination_dir: EL_DIR_PATH)
		do
			volume.destination_dir := a_volume_destination_dir
		end

	set_volume_name (a_volume_name: ZSTRING)
		do
			volume.name := a_volume_name
		end

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

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["@is_dry_run", 								agent do is_dry_run := node.to_boolean end],
				["@task", 										agent do task := node.to_string.as_string_8 end],
				["@test_checksum", 							agent do test_checksum := node.to_natural end],

				["album-art-location/text()", 			agent do album_art_dir := node.to_string end],
				["selected-genres/text()", 				agent do selected_genres.extend (node.to_string) end],

				["DJ-events/@DJ_name", 						agent do dj_events.dj_name := node.to_string end],
				["DJ-events/@default_title", 				agent do dj_events.default_title := node.to_string end],
				["DJ-events/@playlist_dir", 				agent do dj_events.playlist_dir := node.to_string end],
				["DJ-events/publish", 						agent do set_next_context (dj_events.publisher) end],

				["volume/@name", 								agent do volume.name := node.to_string end],
				["volume/@type", 								agent do volume.type := node.to_string end],
				["volume/@destination", 					agent do volume.destination_dir := node.to_string end],
				["volume/@id3_version", 					agent do volume.id3_version := node.to_real end],
				["volume/@is_windows_format", 			agent do volume.is_windows_format := node.to_boolean end],

				["playlist/@root", 							agent do playlist_export.root := node.to_string end],
				["playlist/@subdirectory_name", 			agent do playlist_export.subdirectory_name := node.to_string end],

				["cortina-set/@fade_in", 					agent do cortina_set.fade_in_duration := node.to_real end],
				["cortina-set/@fade_out", 					agent do cortina_set.fade_out_duration := node.to_real end],
				["cortina-set/@clip_duration", 			agent do cortina_set.clip_duration := node.to_integer end],
				["cortina-set/tanda/@tango_count",		agent do cortina_set.tango_count := node.to_integer end],
				["cortina-set/tanda/@tangos_per_vals",	agent do cortina_set.tangos_per_vals := node.to_integer end]
			>>)
		end

feature {NONE} -- Constants

	Default_m3u_extension: ZSTRING
		once
			Result := "m3u"
		end

	Default_playlists_subdirectory_name: ZSTRING
		once
			Result := "playlists"
		end
	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	Root_node_name: STRING = "music-collection"

end