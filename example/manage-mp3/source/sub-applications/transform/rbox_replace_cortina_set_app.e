note
	description: "Summary description for {RBOX_CREATE_CORTINA_SET_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:26:53 GMT (Monday 17th June 2013)"
	revision: "3"

class
	RBOX_REPLACE_CORTINA_SET_APP

inherit
	RBOX_DATABASE_TRANSFORM_APP
		rename
			transform_database as replace_cortinas
		redefine
			create_database, Option_name, normal_initialize, Ask_user_to_quit
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor
			create tanda_format.make (Rhythmbox.Tanda_format.count)
			Rhythmbox.Tanda_format.do_all (agent tanda_format.extend)

			fade_in_duration := (3.0).truncated_to_real
			set_attribute_from_command_opt (fade_in_duration, "fade_in", "Duration of clip fade in")

			fade_out_duration := (3.0).truncated_to_real
			set_attribute_from_command_opt (fade_out_duration, "fade_out", "Duration of clip fade out")

			tanda_count := 25
			set_attribute_from_command_opt (tanda_count, "count", "Number of Cortinas to create")

			if Is_test_mode then
				clip_duration := 2
				source_path := "Unknown.mp3"
				fade_out_duration := (0.02).truncated_to_real
			else
				clip_duration := User_input.integer ("Clip duration")
				source_path := User_input.file_path ("Cortina ")
				log_or_io.put_line ("Close Rhythmbox before continuing")
				log_or_io.put_line ("<Return> to continue")
				io.read_line
			end
		end

feature -- Basic operations

	replace_cortinas
			--
		local
			l_cortina_set: like cortina_set
		do
			log.enter ("replace_cortinas")
			if database.songs_by_location.has (source_path) then
				l_cortina_set := cortina_set
				log_or_io.put_line ("Replacing current set")
				database.replace_cortinas (l_cortina_set)
				database.store
			else
				log_or_io.put_path_field ("ERROR file not found", source_path)
				log_or_io.put_new_line
			end
			log.exit
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
--			Test.do_file_tree_test (
--				Directory.directory_name ("rhythmdb"),
--				agent test_normal_run (?, File.file_name ("workarea/rhythmdb/Music/Pop/Enya/Carribean Blue.02.mp3")), 129355801
--			)

			Test.do_file_tree_test ("rhythmdb",
				agent test_normal_run (?, "workarea/rhythmdb/Music/Recent/March 23/09_-_Fabrizio_De_Andrè_-_Disamistade.mp3"),
				3447750112
			)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH; a_source_path: EL_FILE_PATH)
		do
			log.enter ("test_normal_run")
			normal_initialize
			clip_duration := 5; fade_in_duration.set_item (1.0); fade_out_duration.set_item (1.0)
			source_path := a_source_path
			test_database_dir := data_path
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	create_database
		local
			test_song: RBOX_SONG
		do
			Precursor
			if Is_test_mode then
				test_song := database.songs_by_location [source_path]
				test_song.set_duration (20)
				File_system.delete (cached_song_file_path (test_song, 2))
				File_system.copy (cached_song_file_path (test_song, test_song.duration), source_path)
			end
		end

	cortina_set: EL_ARRAYED_LIST [RBOX_CORTINA_SONG]
		local
			cortina: RBOX_CORTINA_SONG
			source_offset_secs: INTEGER
			full_length_song: RBOX_SONG
		do
			create Result.make (tanda_count)
			full_length_song := database.songs_by_location [source_path]
			tanda_format.start
			from until Result.full loop
				from
					source_offset_secs := 0
				until
					Result.full or else source_offset_secs + clip_duration > full_length_song.duration
				loop
					create cortina.make (
						database.mp3_root_location, full_length_song, tanda_format.item.as_upper,
						Result.count + 1, clip_duration, tanda_count
					)
					log_or_io.put_path_field ("Creating", cortina.mp3_path); log_or_io.put_new_line
					cortina.write_clip (source_offset_secs, fade_in_duration, fade_out_duration)
					Result.extend (cortina)

					tanda_format.forth
					source_offset_secs := source_offset_secs + clip_duration
				end
			end
		end

	clip_duration: INTEGER_REF

	fade_out_duration: REAL_REF

	fade_in_duration: REAL_REF

	source_path: EL_FILE_PATH

	tanda_count: INTEGER_REF

	tanda_format: ARRAYED_CIRCULAR [EL_ASTRING]

feature {NONE} -- Constants

	Option_name: STRING = "replace_cortinas"

	Description: STRING = "Finds any unlisted files in Cortina folders and split them into cortinas"

	Warning_prompt: STRING = "[
		This application will replace the current set of Tango Cortina songs with a new set derived
		from a selected song
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_REPLACE_CORTINA_SET_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"],
				[{RBOX_CORTINA_SONG}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{EL_ID3_INFO}, "*"],

				[{EL_WAV_FADER}, "*"],
				[{EL_MP3_TO_WAV_CLIP_SAVER_COMMAND}, "*"],
				[{EL_WAV_TO_MP3_COMMAND}, "*"]
			>>
		end

	Ask_user_to_quit: BOOLEAN = True

end
