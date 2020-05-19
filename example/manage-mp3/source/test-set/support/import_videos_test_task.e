note
	description: "Import videos test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 17:41:59 GMT (Tuesday 19th May 2020)"
	revision: "9"

class
	IMPORT_VIDEOS_TEST_TASK

inherit
	IMPORT_VIDEOS_TASK
		redefine
			new_song_info_input, video_contains_another_song
		end

create
	make

feature {NONE} -- Implementation

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

	video_contains_another_song: BOOLEAN
		do
		end

feature {EQA_TEST_SET} -- Constants

	Video_song_titles: ARRAY [ZSTRING]
		once
			Result := << "L'Autre Valse d'Amélie", "The Hangmans Reel" >>
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
