note
	description: "Summary description for {RBOX_ADD_ALBUM_PICTURES_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RBOX_ADD_ALBUM_PICTURES_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		rename
			transform_database as add_album_pictures
		redefine
			Option_name, normal_initialize, Ask_user_to_quit, normal_run
		end

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			create album_art_dir
			set_required_attribute_from_command_opt (album_art_dir, "jpeg_dir", "Directory path to jpeg album art")
		end

feature -- Basic operations

	normal_run
		do
			if album_art_dir.exists then
				Precursor
			else
				log_or_io.put_path_field ("Album", album_art_dir)
				log_or_io.put_new_line
				log_or_io.put_line ("Not found")
			end
		end

	add_album_pictures
			--
		do
			database.add_album_pictures (album_art_dir)
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)

			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, "workarea/rhythmdb/album-art"), 3117037089)

			Test.print_checksum_list
		end

	test_normal_run (data_path, a_album_art_dir: EL_DIR_PATH)
			--
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path; album_art_dir := a_album_art_dir
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	album_art_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will edit the RhythmBox configuration database and playlists
	]"

	Option_name: STRING = "add_pictures"

	Description: STRING = "Add album pictures from folder by matching the file name to artist or album name"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_ADD_ALBUM_PICTURES_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{RBOX_SONG}, "*"]
			>>
		end

	Ask_user_to_quit: BOOLEAN = True

end
