note
	description: "Summary description for {RBOX_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-19 13:13:10 GMT (Wednesday 19th June 2013)"
	revision: "2"

deferred class
	RBOX_APPLICATION

inherit
	EL_SUB_APPLICATION

	EL_TESTABLE_APPLICATION

	EL_MODULE_LOG

	EL_MODULE_STRING

	EL_MODULE_EXECUTION_ENVIRONMENT

	MODULE_RHYTHMBOX

	RBOX_MODULE_SONG_FILTER

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			create genre_filter.make_empty
			create path_step_filter.make_empty

			create test_wav_generator.make ("")
			create random.make

			create genre_filter.make_empty
			set_attribute_from_command_opt (genre_filter, "by_genre", "Select only songs with genre")

			create path_step_filter.make_empty
			set_attribute_from_command_opt (
				path_step_filter, "by_path_step", "Select only songs with path containing 'by_path step' argument"
			)

			create critera_list.make (0)

			xml_database_path := Rhythmbox.user_config_dir + "rhythmdb.xml"
			set_attribute_from_command_opt (xml_database_path, "rhythmdb-file", "Path to Rhythmbox database: rhythmdb.xml")

			create dry_run_output_dir
			create is_dry_run
			is_dry_run.set_item (Args.word_option_exists ("dry_run"))
			if is_dry_run.item then
				dry_run_output_dir := Directory.home.joined_dir_path ("Desktop/Music")
				set_attribute_from_command_opt (dry_run_output_dir, "dry_run", "Output directory for dry run")
			end
		end

	create_database
			--
		local
			playlist_path: EL_FILE_PATH
--			test_database_dir_abs: EL_DIR_PATH
			song: RBOX_SONG
			l_duration: INTEGER
			modification_time: DATE_TIME
		do
			log.enter ("create_database")
			if Is_test_mode then
				create modification_time.make (2011, 11, 11, 11, 11, 11)
				xml_database_path := test_database_dir + "rhythmdb.xml"
--				test_database_dir_abs := Directory.joined_path (Directory.current_working_directory, test_database_dir)

				substitute_work_area_variable (test_database_dir, xml_database_path)

				playlist_path := xml_database_path.parent + "playlists.xml"
				substitute_work_area_variable (test_database_dir, playlist_path)

				create database.make (xml_database_path)

				if not (test_database_dir + "Music").exists then
					across database.songs as l_song loop
						song := l_song.item
						if not song.is_hidden then
							l_duration := song.duration
							if l_duration > 10 then
								l_duration := l_duration // 10
							end
							File_system.make_directory (song.mp3_path.parent)
							File_system.copy (cached_song_file_path (song, l_duration), song.mp3_path)
						end
					end
				end
				database.update_index_by_track_id
			else
				create database.make (xml_database_path)
			end

			log.exit
		end

feature -- Status query

	is_dry_run: BOOLEAN_REF

feature -- Element change

	set_song_genre (song: RBOX_SONG; genre: STRING)
			--
		do
			song.set_genre (genre)
		end

	set_song_artist (song: RBOX_SONG; artist: STRING)
			--
		do
			song.set_artist (artist)
		end

feature {NONE} -- Implementation

	substitute_work_area_variable (data_path: EL_DIR_PATH; xml_file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			xml_text: STRING
		do
			xml_text := File_system.plain_text (xml_file_path)
			xml_text.replace_substring_all ("$WORKAREA", data_path.to_string)

			create xml_file.make_open_write (xml_file_path.unicode)
			xml_file.put_string (xml_text)
			xml_file.close
		end

	cached_song_file_path (song: RBOX_SONG; a_duration: INTEGER): EL_FILE_PATH
			-- Path to auto generated mp3 file under build directory
		require
			valid_duration: a_duration > 0
		local
			mp3_writer: EL_WAV_TO_MP3_COMMAND
			relative_steps: EL_PATH_STEPS
			wav_path: EL_FILE_PATH
			id3_info: EL_ID3_INFO
		do
			log.put_path_field ("Reading", song.mp3_path)
			log.put_new_line

			relative_steps := song.mp3_path.relative_path (database.mp3_root_location).steps
			Result := Directory.path ("build").joined_file_steps (relative_steps)
			if not Result.exists then
				File_system.make_directory (Result.parent)
				wav_path := Result.with_new_extension ("wav")

				-- Create a unique random wav file
				test_wav_generator.set_output_file_path (wav_path)
				test_wav_generator.set_frequency_lower (100 + (200 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_frequency_upper (600  + (600 * random.real_item).rounded)
				random.forth
				test_wav_generator.set_cycles_per_sec ((1.0 + random.real_item.to_double).truncated_to_real)
				random.forth

				if a_duration > 0 then
					test_wav_generator.set_duration (a_duration * 1000)
				end
				test_wav_generator.execute

				create mp3_writer.make (wav_path, Result)
				mp3_writer.set_bit_rate_per_channel (48)
				mp3_writer.set_num_channels (1)
				mp3_writer.execute
				File_system.remove_file (wav_path)

				create id3_info.make (wav_path.with_new_extension ("mp3"))
				song.write_id3_info (id3_info)

			end
		ensure
			file_exists: Result.exists
		end

	playlists_xml_path: EL_FILE_PATH
		do
			Result := xml_database_path.parent + "playlists.xml"
		end

feature {NONE} -- Implementation: attributes

	critera_list: ARRAYED_LIST [PREDICATE [ANY, TUPLE [RBOX_SONG]]]

	database: RBOX_DATABASE

	test_database_dir: EL_DIR_PATH

	dry_run_output_dir: EL_DIR_PATH

	genre_filter: STRING

	path_step_filter: STRING

	xml_database_path: EL_FILE_PATH

	random: RANDOM

	test_wav_generator: EL_WAV_GENERATION_COMMAND

end
