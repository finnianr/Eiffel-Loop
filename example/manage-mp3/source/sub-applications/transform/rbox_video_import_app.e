note
	description: "Summary description for {RBOX_VIDEO_IMPORT_APP}."

	to_do: "[
		Artist not being set from folder name. Perhaps not written to into MP3.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-17 22:27:20 GMT (Monday 17th June 2013)"
	revision: "3"

class
	RBOX_VIDEO_IMPORT_APP


inherit
	RBOX_DATABASE_TRANSFORM_APP
		rename
			transform_database as import_videos
		redefine
			create_database, Option_name, Ask_user_to_quit
		end

create
	make

feature -- Basic operations

	import_videos
			--
		local
			video_properties: EL_AUDIO_PROPERTIES_COMMAND; video_to_mp3_command: EL_VIDEO_TO_MP3_COMMAND
			l_video_info: like video_info; l_song: RBOX_SONG; time_zero: TIME
			duration_time: TIME_DURATION
		do
			create time_zero.make_by_compact_time (0)
			across ("flv,m4v,mp4,mov").split (',') as extension loop
				across File_system.file_list (database.mp3_root_location, "*." + extension.item) as video_path loop
					log_or_io.put_path_field ("Converting", video_path.item); log_or_io.put_new_line
					create video_properties.make (video_path.item)

					l_video_info := video_info (video_path.item, video_properties.duration)
					l_song := l_video_info.song

					create video_to_mp3_command.make (video_path.item, l_song.mp3_path)

					if l_video_info.time_from.seconds > 0 then
						video_to_mp3_command.set_offset_time (l_video_info.time_from)
						duration_time := l_video_info.time_to.relative_duration (l_video_info.time_from)
						-- duration has extra 0.1 secs added to prevent rounding error below the required duration
						duration_time.fine_second_add (0.1)
						video_to_mp3_command.set_duration (time_zero + duration_time)
					end
					if video_properties.bit_rate < 128 then
						video_to_mp3_command.set_bit_rate (128)

					elseif video_properties.bit_rate < 192 then
						video_to_mp3_command.set_bit_rate (192)
					else
						video_to_mp3_command.set_bit_rate (256)
					end
					video_to_mp3_command.execute
					File_system.delete (video_path.item)
					l_song.write_id3_info (l_song.id3_info)

					database.extend (l_song)
				end
			end
			database.store
		end

	create_database
		local
			l_song: RBOX_SONG
			video_path: EL_FILE_PATH
		do
			Precursor
			if Is_test_mode then
				database.songs.find_first (
					create {EL_ASTRING}.make_from_latin1 ("L'Autre Valse d'Amélie"), agent {RBOX_SONG}.title
				)
				l_song := database.songs.item
				database.songs.remove
				database.remove (l_song)

				video_path := l_song.mp3_path.parent + String.template ("$S($S)[$S]{0:01-0:02}.mp4").substituted (<<
					l_song.title, l_song.album_artists, l_song.album
				>>)
				write_video (l_song.mp3_path, video_path)

				database.songs.find_first (
					create {EL_ASTRING}.make_from_latin1 ("The Hangmans Reel"), agent {RBOX_SONG}.title
				)
				l_song := database.songs.item
				database.songs.remove
				database.remove (l_song)

				write_video (l_song.mp3_path, l_song.mp3_path.parent + (l_song.title + ".mp4"))
			end
		end

	write_video (input_path, output_path: EL_FILE_PATH)
		do
			AVconv_mp3_to_mp4.set_variables_from_array (<< ["input_path", input_path], ["output_path", output_path] >>)
			AVconv_mp3_to_mp4.execute
			File_system.delete (input_path)
		end

feature -- Testing operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
			Test.do_file_tree_test ("rhythmdb", agent test_normal_run, 3393405797)

			Test.print_checksum_list
		end

	test_normal_run (data_path: EL_DIR_PATH)
		do
			log.enter ("test_normal_run")
			normal_initialize
			test_database_dir := data_path
			normal_run
			log.exit
		end

feature {NONE} -- Implementation

	video_info (a_file_path: EL_FILE_PATH; a_time_duration: TIME): TUPLE [song: RBOX_SONG; time_from, time_to: TIME]
		local
			video_title_parser: VIDEO_TITLE_PARSER
			relative_path_steps: EL_PATH_STEPS
			l_song: RBOX_SONG
		do
			create Result
			l_song := database.create_song
			relative_path_steps := a_file_path.relative_path (database.mp3_root_location_steps).steps
			create video_title_parser.make (a_time_duration)
			video_title_parser.parse (a_file_path.without_extension.steps.last)

			l_song.set_title (video_title_parser.title)
			l_song.set_genre (relative_path_steps.first)
			l_song.set_artist (relative_path_steps.i_th (2))
			if not video_title_parser.album_artists.is_empty then
				l_song.set_album_artists_list (video_title_parser.album_artists)
			end
			if video_title_parser.album.is_empty then
				l_song.set_album ("Youtube")
			else
				l_song.set_album (video_title_parser.album)
			end
			if video_title_parser.year > 0 then
				l_song.set_recording_year (video_title_parser.year)
			end

			Result.time_from := video_title_parser.time_from
			Result.time_to := video_title_parser.time_to

			l_song.set_mp3_path (l_song.unique_normalized_mp3_path)
			Result.song := l_song
		end

feature {NONE} -- Constants

	Option_name: STRING = "import_videos"
			--
	Description: STRING = "[
		Import any videos and convert them to mp3, tagging them according to the folder location.
		Format of song file name is as follows: "<title> [<album-artist>](<album>) {<time-from>-<time-to>}.mp4"
		The option times specifies a video clip.
	]"

	Warning_prompt: STRING = "[
		This application will insert new songs into the RhythmBox configuration database
	]"

	AVconv_mp3_to_mp4: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("avconv_mp3_to_mp4", "[
				avconv -i "$input_path" -ab 48k -s vga "$output_path"
			]")
		end

	Ask_user_to_quit: BOOLEAN = True

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RBOX_VIDEO_IMPORT_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{RBOX_SONG}, "*"],
				[{RBOX_DATABASE}, "*"],
				[{EL_LIBID3_FRAME}, "-*"],
				[{EL_ID3_INFO}, "*"],
				[{EL_GENERAL_OS_COMMAND}, "*"],
				[{EL_VIDEO_TO_MP3_COMMAND}, "*"]
			>>
		end

end
