note
	description: "[
		If an entry has been removed from library (marked hidden) because it was a duplicate,
		then any playlist entries referring to this hidden item it will be replaced by a
		visible song with a matching artist and title.

		If word option: -autoedit is specified on command line then

		1. procedure cleanup_id3_tags will delete certain tags,

		2. procedure update_id3version will migrate ver 1.x and 2.3 tags to 2.4,

		3. procedure edit_song_fields will normalize word case of the artist and title field and
		if the year of recording field is blank it will set it with anything that looks like a year in the title.

		4. procedure update_and_relocate_song will add a unique id tag named RBOX.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:27:40 GMT (Monday 17th June 2013)"
	revision: "2"

class
	RBOX_ARTIST_AND_TITLE_NORMALIZATION_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		redefine
			Option_name, database
		end

create
	make

feature -- Basic operations

	transform_database
			--
		do
			database.normalize_artist_and_title_fields
		end

--	write_id3_tags (song: RBOX_SONG)
--			--
--		do
--			song.normalize_artist_and_title_fields
--			set_song_time_last_seen (song, utc_time_now)
--		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3" >>)
--			Test.do_file_tree_test ("rhythmdb", agent test_create_mp3_files_from_test_db, 174573304)
--			Test.do_file_tree_test ("rhythmdb", agent test_sort_by_genre_and_artist, 2502599686)
--			Test.do_file_tree_test ("rhythmdb", agent test_run_with_contained_path_step, 483348154)
--			Test.do_file_tree_test ("rhythmdb", agent test_run_with_genre (?, "Vals"), 483348154)

			Test.do_file_tree_test ("rhythmdb-classical", agent test_run_with_genre (?, "Classical"), 483348154)

			Test.print_checksum_list
		end

	test_run_with_contained_path_step (data_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_run_with_contained_path_step")
			test_database_dir := data_path
			normal_initialize

			critera_list.extend (agent {RBOX_SONG}.is_modified)
			critera_list.extend (agent Song_filter.contains_path_step (?, "Music"))
			transform_database

			create database.make (database.xml_database_path)
			transform_database
			log.exit
		end

	test_run_with_genre (data_path: EL_DIR_PATH; genre: STRING)
			--
		do
			log.enter ("test_run_with_genre")
			test_database_dir := data_path
			normal_initialize

			critera_list.extend (agent {RBOX_SONG}.is_modified)
			critera_list.extend (agent Song_filter.is_of_genre (?, genre))
			transform_database

			create database.make (database.xml_database_path)
			transform_database
			log.exit
		end

feature {NONE} -- Implementation

	database: RBOX_FINNIANS_DATABASE

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will edit the RhythmBox configuration database and playlists,
		update all mp3 tags to match Rhythmbox edits.
		If word option: -autoedit is specified on command line, it will delete certain tags
		and add a unique id tag. These changes are not reversible.
	]"

	Unix_epoch: DATE_TIME
			--
		once
			create Result.make_by_date (create {DATE}.make (1970, 1, 1))
		end

	Option_name: STRING = "normalize_artist_and_title"
			--

	Description: STRING = "Normalizes artist and title fields"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_ARTIST_AND_TITLE_NORMALIZATION_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"]
			>>
		end

end
