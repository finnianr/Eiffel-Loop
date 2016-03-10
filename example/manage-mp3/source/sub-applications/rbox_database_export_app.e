note
	description: "Summary description for {RBOX_DATABASE_EXPORT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:24:54 GMT (Monday 17th June 2013)"
	revision: "2"

class
	RBOX_DATABASE_EXPORT_APP

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
		do
			Precursor

			create genre_list_path
			set_attribute_from_command_opt (genre_list_path, "genres", "Path to genre list in Pyxis format")

		end

feature -- Basic operations

	do_export
			--
		local
			selected_genres: like genre_list
		do
			selected_genres := genre_list
			across selected_genres as genre loop
				if database.is_valid_genre (genre.item) then
					log_or_io.put_string_field ("Genre " + genre.cursor_index.out, genre.item)
				else
					log_or_io.put_string_field ("Invalid genre", genre.item)
				end
				log_or_io.put_new_line
			end
			if not selected_genres.is_empty then
				device.set_criteria (agent Song_filter.is_in_genre_list (?, selected_genres))
			else
				device.set_criteria (agent Song_filter.is_any)
			end
			device.export_songs
		end

feature -- Tests

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)

			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, ""), 3973722899)
--			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, "workarea/rhythmdb/export_genres.pyx"), 1229590894)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH; a_genre_list_path: EL_FILE_PATH)
			--
		local
			title: EL_ASTRING
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			genre_list_path := a_genre_list_path
			export_path := test_database_dir.joined_dir_path ("device")
			File_system.make_directory (export_path)

			normal_run

			log.put_line ("Hiding Classical songs")

			database.songs.set_criteria_with_default (agent Song_filter.is_of_genre (?, "Classical"))
			database.songs.query_results.do_all (agent {RBOX_SONG}.hide)

			log.put_line ("Changing titles on Rock Songs")
			database.songs.set_criteria_with_default (agent Song_filter.is_of_genre (?, "Rock"))
			across database.songs.query_results as song loop
				title := song.item.title
				title.prepend_character ('X')
				song.item.set_title (title)
				song.item.update_checksum
			end

			-- See what happens
			database.store

			log.put_new_line
			log.put_line ("Export again")
			normal_run

			log.exit
		end

feature {NONE} -- Implementation

	genre_list_path: EL_FILE_PATH

	genre_list: PYXIS_GENRE_LIST
		do
			if genre_list_path.is_empty then
				create Result.make
			else
				create Result.make_from_file (genre_list_path)
			end
		end

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = True

	Option_name: STRING= "db_export"
			--
	Description: STRING = "Export selected genres or entire music library to specified directory"

	Destination_description: STRING = "Root directory for exported database"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_DATABASE_EXPORT_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "-*"],
				[{RBOX_DATABASE}, "*"],
				[{MP3_DEVICE}, "*"],
				[{EL_WAV_TO_MP3_COMMAND}, "*"],
				[{EL_WAV_GENERATION_COMMAND}, "*"],
				[{EL_LIBID3_FRAME}, "-*"]
			>>
		end

end
