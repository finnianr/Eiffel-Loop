note
	description: "[
		Application to sort mp3 files into directories according to genre and artist set in
		Rhythmbox music library database. Playlist locations will be updated to match new
		locations.
	]"

	warning: "[
		USE AT YOUR OWN RISK.
		
		This application will edit the RhythmBox configuration database and playlists,
		sort the locations of your mp3 files and update all mp3 tags to match Rhythmbox edits.
		If word option: -autoedit is specified on command line, it will delete certain tags 
		and add a unique id tag. These changes are not reversible.

		Do not use without first backing up your Rhythmbox MP3 collection, playlists and music library database.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 22:00:46 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	RBOX_COLLATION_BY_GENRE_AND_ARTIST_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		redefine
			Option_name, Ask_user_to_quit
		end

	EL_MODULE_URL

create
	make

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run (?, False), 2280790217)

--			Test.do_file_tree_test (Directory.directory_name ("rhythmdb-classical"), agent test_normal_run (?, True), 2486020034)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH; dry_run: BOOLEAN)
			--
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			is_dry_run.set_item (dry_run)
			if dry_run then
				dry_run_output_dir := data_path.joined_dir_path ("Music-new")
			end

			normal_run

			normal_run

			log.exit
		end

feature {NONE} -- Implementation

	transform_database
		do
			database.collate_songs (dry_run_output_dir)
		end

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will edit the RhythmBox configuration database and playlists,
		sort the locations of your mp3 files
	]"

	Option_name: STRING = "collate_by_genre_and_artist"
			--

	Description: STRING = "Collate mp3 files into directories by genre and artist"

	Ask_user_to_quit: BOOLEAN = True

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_COLLATION_BY_GENRE_AND_ARTIST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{RBOX_SONG}, "*"]
			>>
		end

end
