note
	description: "[
		Import mp3 not currently in database and set artist and genre according to current location in
		Music/<genre>/<artist/composer>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:33:25 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	RBOX_IMPORT_NEW_MP3_APP

inherit
	RBOX_APPLICATION
		redefine
			Option_name, Ask_user_to_quit, normal_initialize
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			create_database
		end

feature -- Basic operations

	normal_run
			--
		local
			new_mp3_list: LINKED_LIST [EL_FILE_PATH]
		do
			create new_mp3_list.make
			across File_system.file_list (database.mp3_root_location, "*.mp3") as mp3_path loop
				if not database.songs_by_location.has (mp3_path.item) then
					new_mp3_list.extend (mp3_path.item)
				end
			end
			if not new_mp3_list.is_empty then
				log_or_io.put_line ("Importing new MP3")
				log_or_io.put_new_line
				new_mp3_list.do_all (agent database.import_mp3)
				database.store
			else
				log_or_io.put_line ("Nothing to import")
			end
		end

feature -- Test operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 483348154)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH)
			--
		local
			song1, song2: RBOX_SONG
		do
			log.enter ("test_normal_run")
			test_database_dir := data_path
			normal_initialize

			song1 := database.create_song
			song1.set_mp3_path (database.mp3_root_location + "Tango/Carlos Di Sarli/disarli.mp3")
			song1.set_title ("La Racha")
			song1.set_genre ("Latin")
			song1.set_artist ("Carlos Di Sarli")
			song1.set_album ("Carlos Di Sarli greatest hits")

			song2 := database.create_song
			song2.set_mp3_path (database.mp3_root_location + "Vals/Edgardo Donato/estrellita.mp3")
			song2.set_title ("Estrellita Mia")
			song2.set_genre ("Latin")
			song2.set_artist ("Edgardo Donato with Horacio Lagos, Romeo Gavioli and Lita Morales")
			song2.set_album ("Carlos Di Sarli greatest hits")

			song1.update_checksum

			random.set_seed (song1.last_checksum.to_integer_32)
			across << song1, song2 >> as song loop
				File_system.make_directory (song.item.mp3_path.parent)
				File_system.copy (cached_song_file_path (song.item, 2), song.item.mp3_path)
			end

			normal_run
			normal_run

			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "import_new_mp3"

	Description: STRING = "Import new MP3 and tag according to genre and artist location"

	Ask_user_to_quit: BOOLEAN = True

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_IMPORT_NEW_MP3_APP}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
