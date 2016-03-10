note
	description: "Summary description for {TEST_VIDEO_IMPORT_MUSIC_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	new_song_info_input (
		duration_time: TIME_DURATION; title, lead_artist: ASTRING

	): TUPLE [time_from, time_to: TIME; title, album_artists, album_name: ASTRING; recording_year: INTEGER]
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
			Result.album_artists := song.album_artists
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
			AVconv_mp3_to_mp4.put_variable (song.mp3_path, "mp3_path")
			AVconv_mp3_to_mp4.put_variable (song.mp3_path.parent + (song.title + ".mp4"), "mp4_path")
			AVconv_mp3_to_mp4.put_variable ("workarea/rhythmdb/album-art/Artist/Unknown.jpeg", "jpeg_path")
			AVconv_mp3_to_mp4.execute
		end

feature {NONE} -- Constants

	Video_song_titles: ARRAY [ASTRING]
		once
			Result := << "L'Autre Valse d'Amélie", "The Hangmans Reel">>
			Result.compare_objects
		end

	Video_songs: EL_ASTRING_HASH_TABLE [RBOX_SONG]
		once
			create Result.make_equal (2)
			across Database.songs.query (is_video_song) as song loop
				Result [song.item.title] := song.item
			end
		end

	AVconv_mp3_to_mp4: EL_GENERAL_OS_COMMAND
		once
			create Result.make ("[
				avconv -v quiet -i "$mp3_path"
				-f image2 -loop 1 -r 10 -i "$jpeg_path"
				-shortest -strict experimental -acodec aac -c:v libx264 -crf 23 -ab 48000 "$mp4_path"
			]")
		end
end
