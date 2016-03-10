note
	description: "Synchronize directory of media files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:25:05 GMT (Monday 17th June 2013)"
	revision: "2"

class
	MEDIA_SYNC_APP

inherit
	RBOX_APPLICATION
		redefine
			Ask_user_to_quit, Option_name, Installer, Input_path_option_name, normal_initialize
		end

	EL_MODULE_USER_INPUT

--	EL_EYED3_VERSION_CONSTANTS

	SHARED_MEDIA_SYNC_CONFIGURATION

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			if Is_test_mode then
				Precursor
			end
			set_app_configuration_option_name (Option_name)
			script_path := "test.msync"
			set_attribute_from_command_opt (script_path, Input_path_option_name, "Path to synchronization config file")
		end

feature -- Basic operations

	normal_run
			--
		local
			is_user_sure: BOOLEAN
		do
			if script_path.exists then
				create script.make (script_path)
				if script.command_actions.count > 0 then
					if script.new_items_count > 0 then
						log_or_io.put_new_line
						log_or_io.put_string ("Total of ")
						log_or_io.put_integer (script.new_items_count)
						log_or_io.put_string (" files to copy%N")
					end
					log_or_io.put_new_line
					log_or_io.put_string ("Are you sure? (y/n) ")
					is_user_sure := User_input.entered_letter ('y')
					log_or_io.put_new_line

					if is_user_sure then
						script.command_actions.call ([])
					end
				else
					log_or_io.put_line ("ALREADY SYNCHRONIZED")
				end
			end
		end


feature -- Test operations

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "mp3" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_file_move_delete_and_new, 174573304)

--			Test.do_file_tree_test ("rhythmdb", agent test_single_new_directory, 174573304)
		end

	test_single_new_directory (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_single_new_directory")
			test_database_dir := data_path
			normal_initialize

			critera_list.extend (agent {RBOX_SONG}.is_modified)
			critera_list.extend (agent Song_filter.contains_path_step (?, "Music"))
--			database.songs.do_if (
--				agent normalize_song_location_and_id3_tags, song_matches
--			)
			script_path := data_path + "Music-Vals.msync"
			substitute_work_area_variable (data_path, script_path)

			normal_run
			log.exit
		end

	test_file_move_delete_and_new (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_file_move_delete_and_new")
			test_database_dir := data_path
			normal_initialize

			critera_list.extend (agent {RBOX_SONG}.is_modified)
			critera_list.extend (agent Song_filter.contains_path_step (?, "Music"))
--			database.songs.do_if (
--				agent normalize_song_location_and_id3_tags, song_matches
--			)
			script_path := data_path + "Music.msync"
			substitute_work_area_variable (data_path, script_path)
			normal_run

			-- Change some stuff
			database.songs.do_if (
				agent set_song_genre (?, "Vals"), -- Tango to Vals
				agent Song_filter.is_with_artist_and_title (?, "Enrique Rodríguez", "Suerte Loca")
			)
			database.songs.do_if (
				agent set_song_genre (?, "Tango"), -- Vals to Tango
				agent Song_filter.is_with_artist_and_title (?, "Enrique Rodríguez", "Con tu Mirar")
			)
			database.songs.do_if (
				agent set_song_artist (?, "Francisco Canaro"), -- "Francisco Lomuto" to "Francisco Canaro"
				agent Song_filter.is_with_artist_and_title (?, "Francisco Lomuto", "Lo Que Vieron Tus Ojos")
			)
--			database.songs.do_if (
--				agent normalize_song_location_and_id3_tags, song_matches
--			)
			normal_run
			log.exit
		end

feature {NONE} -- Test implementation


feature {NONE} -- Implementation

	transform_song (song: RBOX_SONG)
		do
		end

	script_path: EL_FILE_PATH

	script: MEDIA_SYNC_XML_SCRIPT

feature {NONE} -- Constants

	Option_name: STRING = "media_sync"
			--

	Description: STRING = "Synchronize media files specified in 'msync' xml file"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Audio utilities/Synchronize MP3 files")
		end

	Input_path_option_name: STRING = "script"

	Ask_user_to_quit: BOOLEAN = true

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{MEDIA_SYNC_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{MEDIA_SYNC_XML_SCRIPT}, "*"],
				[{COPY_UNIQUE_MP3_FILE_COMMAND}, "execute"],
				[{EL_DELETE_PATH_COMMAND}, "execute"],
				[{EL_MOVE_FILE_COMMAND}, "execute"],
				[{MEDIA_ITEM_SET [MEDIA_ITEM]}, "is_equal"],
				[{MEDIA_ITEM_SET [UNIQUELY_IDENTIFIABLE_MEDIA_ITEM]}, "*"],
				[{SMALL_DEVICE_MP3_MEDIA_ITEM}, "is_equal"],
				[{EL_UNDERBIT_ID3_TAG_INFO}, "-*"],
				[{EL_XPATH_NODE_CONTEXT}, "-*"],
				[{EL_VTD_EXCEPTIONS}, "*"],
				[{EL_MOVE_FILE_COMMAND}, "*"]

			>>
		end

end
