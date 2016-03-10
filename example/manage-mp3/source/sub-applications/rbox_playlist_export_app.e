note
	description: "Summary description for {RBOX_PLAYLIST_EXPORT_APP}."

	to_do: "[
		Add silence track after songs that have BMP set to 1, 2 or 3
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:25:22 GMT (Monday 17th June 2013)"
	revision: "2"

class
	RBOX_PLAYLIST_EXPORT_APP

inherit
	RBOX_EXPORT_APPLICATION
		redefine
			Option_name, normal_initialize, Ask_user_to_quit
		end

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		local
			is_nokia_device: BOOLEAN_REF
		do
			Precursor
			create playlist_export_args

			playlist_export_args.directory_prefix := ""
			set_attribute_from_command_opt (
				playlist_export_args.directory_prefix, "directory_prefix", "Directory prefix to song locations"
			)

			playlist_export_args.m3u_extension := "m3u"
			set_attribute_from_command_opt (playlist_export_args.m3u_extension, "m3u_ext", "[m3u or m3u8]")

			playlist_export_args.playlist_subdirectory := ""
			set_attribute_from_command_opt (
				playlist_export_args.playlist_subdirectory, "playlist_subdirectory", "Subdirectory of destination for playlists"
			)

			create is_nokia_device
			set_attribute_from_command_opt (is_nokia_device, "nokia", "Is export device a nokia phone")
			playlist_export_args.is_nokia_device := is_nokia_device.item

		end

feature -- Basic operations

	do_export
			--
		do
			device.export_playlists (playlist_export_args)
		end

feature -- Tests

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, False), 1759111227)
--			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, True), 585376216)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH; is_nokia_device: BOOLEAN)
			--
		do
			log.enter ("test_normal_run")
			normal_initialize
			export_path := data_path.joined_dir_path ("device")
			playlist_export_args.playlist_subdirectory := "playlist"
			File_system.make_directory (export_path)

			playlist_export_args.is_nokia_device := is_nokia_device
			if is_nokia_device then
				playlist_export_args.directory_prefix := "E:/Music"
			else
				playlist_export_args.directory_prefix := "share/Music"
			end
			test_database_dir := data_path
			normal_run
			create database.make (xml_database_path)
			device.export_playlists (playlist_export_args)
			log.exit
		end

feature {NONE} -- Implementation

	playlist_export_args: like device.Type_export_parameters

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = True

	Option_name: STRING = "export_playlists"

	Description: STRING = "Export playlist songs with normalized directory structure <genre>/<artist>/<title>.mp3"

	Destination_description: STRING = "Destination path for exported playlists"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_PLAYLIST_EXPORT_APP}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"],
				[{MP3_DEVICE}, "*"],

				[{EL_WAV_TO_MP3_COMMAND}, "-*"],
				[{EL_MOVE_FILE_COMMAND}, "-*"],
				[{EL_WAV_GENERATION_COMMAND}, "-*"]
			>>
		end

end
