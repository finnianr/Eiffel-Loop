note
	description: "Test set for class [$source IMPORT_VIDEOS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-23 13:15:59 GMT (Thursday 23rd April 2020)"
	revision: "2"

class
	IMPORT_VIDEOS_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [IMPORT_VIDEOS_TEST_TASK]
		redefine
			do_task
		end

feature {NONE} -- Implementation

	do_task
		do
			across task.Video_songs as song loop
				write_video_song (song.item)
				Database.delete (song.item)
			end

			task.apply
			print_rhythmdb_xml; print_playlist_xml
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
			AVconv_mp3_to_mp4.put_file_path ("jpeg_path", work_area_data_dir + "album-art/Other/Unknown.jpeg")
			AVconv_mp3_to_mp4.execute
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

	Checksum: NATURAL = 3938710347

	Task_config: STRING = "[
		import_videos:
			is_dry_run = false; music_dir = "workarea/rhythmdb/Music"
	]"

end
