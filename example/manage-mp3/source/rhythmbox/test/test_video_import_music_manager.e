note
	description: "Summary description for {TEST_VIDEO_IMPORT_MUSIC_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 14:19:46 GMT (Thursday 23rd June 2016)"
	revision: "4"

class
	TEST_VIDEO_IMPORT_MUSIC_MANAGER

inherit
	TEST_MUSIC_MANAGER
		redefine
			make, new_song_info_input, video_contains_another_song
		end

create
	make

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_config: like config)
		do
			Precursor (a_config)
			convert_songs_to_video
		end

feature {NONE} -- Factory

	new_song_info_input (duration_time: TIME_DURATION; title, lead_artist: ZSTRING):  like Type_song_info
		local
			song: RBOX_SONG
		do
			create Result
			song := Video_songs [title]
			if title ~ Video_song_titles [1] then
				Result.time_from := new_time (5.0)
				Result.time_to := new_time (8.0)
			else
				Result.time_from := new_time (0)
				Result.time_to := new_time (duration_time.fine_seconds_count)
			end
			Result.title := song.title
			Result.album_artists := song.album_artist
			Result.album_name := song.album
			Result.recording_year := song.recording_year
		end

feature {NONE} -- Implementation

	convert_songs_to_video
		do
			across Video_songs as song loop
				write_video_song (song.item)
			end
			Database.delete (is_video_song)
		end

	is_video_song: EL_QUERY_CONDITION [RBOX_SONG]
		do
			Result := not song_is_hidden and predicate (
				agent (song: RBOX_SONG): BOOLEAN do Result := Video_song_titles.has (song.title) end
			)
		end

	video_contains_another_song: BOOLEAN
		do
		end

	write_video_song (song: RBOX_SONG)
		do
			AVconv_mp3_to_mp4.put_path ("mp3_path", song.mp3_path)
			AVconv_mp3_to_mp4.put_path ("mp4_path", song.mp3_path.parent + (song.title + ".mp4"))
			AVconv_mp3_to_mp4.put_file_path ("jpeg_path", "workarea/rhythmdb/album-art/Artist/Unknown.jpeg")
			AVconv_mp3_to_mp4.execute
		end

feature {NONE} -- Constants

	Video_song_titles: ARRAY [ZSTRING]
		once
			Result := << "L'Autre Valse d'Amélie", "The Hangmans Reel">>
			Result.compare_objects
		end

	Video_songs: EL_ZSTRING_HASH_TABLE [RBOX_SONG]
		once
			create Result.make_equal (2)
			across Database.songs.query (is_video_song) as song loop
				Result [song.item.title] := song.item
			end
		end

	AVconv_mp3_to_mp4: EL_OS_COMMAND
		once
			create Result.make_with_name ("avconv.generate_mp4", "[
				avconv -v quiet -i $mp3_path
				-f image2 -loop 1 -r 10 -i $jpeg_path
				-shortest -strict experimental -acodec aac -c:v libx264 -crf 23 -ab 48000 $mp4_path
			]")
		end
end