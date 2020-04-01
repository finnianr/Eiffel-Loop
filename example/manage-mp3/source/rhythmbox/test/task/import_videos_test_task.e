note
	description: "Import videos test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-01 13:14:56 GMT (Wednesday 1st April 2020)"
	revision: "6"

class
	IMPORT_VIDEOS_TEST_TASK

inherit
	IMPORT_VIDEOS_TASK
		undefine
			root_node_name
		redefine
			apply, new_song_info_input, video_contains_another_song
		end

	TEST_MANAGEMENT_TASK

feature -- Basic operations

	apply
		do
			across Video_songs as song loop
				write_video_song (song.item)
				Database.delete (song.item)
			end
			Precursor
		end

feature {NONE} -- Factory

	new_song_info_input (duration_time: TIME_DURATION; title, lead_artist: ZSTRING): like SONG_INFO
		do
			create Result
			Result.song := Video_songs [title]
			if title ~ Video_song_titles [1] then
				Result.time_from := new_time (5.0)
				Result.time_to := new_time (8.0)
			else
				Result.time_from := new_time (0)
				Result.time_to := new_time (duration_time.fine_seconds_count)
			end
		end

feature {NONE} -- Implementation

	write_video_song (song: RBOX_SONG)
		local
			mp4_path: EL_FILE_PATH
		do
			AVconv_mp3_to_mp4.put_path ("mp3_path", song.mp3_path)

			from mp4_path := song.unique_normalized_mp3_path until not mp4_path.has_dot_extension loop
				mp4_path.remove_extension
			end
			mp4_path.add_extension ("mp4")
			File_system.make_directory (mp4_path.parent)
			AVconv_mp3_to_mp4.put_path ("mp4_path", mp4_path)
			AVconv_mp3_to_mp4.put_file_path ("jpeg_path", "workarea/rhythmdb/album-art/Other/Unknown.jpeg")
			AVconv_mp3_to_mp4.execute
		end

	video_contains_another_song: BOOLEAN
		do
		end

feature {NONE} -- Constants

	AVconv_mp3_to_mp4: EL_OS_COMMAND
		once
			create Result.make_with_name ("avconv.generate_mp4", "[
				avconv -v quiet -i $mp3_path
				-f image2 -loop 1 -r 10 -i $jpeg_path
				-shortest -strict experimental -acodec aac -c:v libx264 -crf 23 -ab 48000 $mp4_path
			]")
		end

	Video_song_titles: ARRAY [ZSTRING]
		once
			Result := << "L'Autre Valse d'Amélie", "The Hangmans Reel">>
			Result.compare_objects
		end

	Video_songs: EL_ZSTRING_HASH_TABLE [RBOX_SONG]
		once
			create Result.make_equal (2)
			across Database.songs.query (not song_is_hidden) as song loop
				if Video_song_titles.has (song.item.title) then
					Result.put (song.item, song.item.title)
				end
			end
		end

end
