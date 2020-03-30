note
	description: "Archive songs task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 8:04:08 GMT (Monday 30th March 2020)"
	revision: "3"

class
	ARCHIVE_SONGS_TASK

inherit
	RBOX_MANAGEMENT_TASK
		redefine
			error_check
		end

create
	make

feature -- Access

	archive_dir: EL_DIR_PATH
		-- directory for archived music

feature -- Basic operations

	apply
			-- archive songs in the Archive playlist
		local
			silence_1_sec: RBOX_SONG
		do
			silence_1_sec := Database.silence_intervals [1]
			if Database.archive_playlist.count = 1 then
				lio.put_line ("No songs listed in %"Music Extra%" (except %"Silence 1 sec%")")
			else
				across Database.archive_playlist as song loop
					lio.put_labeled_string ("Song", song.item.mp3_relative_path)
					if song.item = silence_1_sec then
						lio.put_line (" is silence")
					elseif Database.is_song_in_any_playlist (song.item) then
						lio.put_line (" belongs to a playlist")
					else
						Database.remove (song.item)
						song.item.set_music_dir (archive_dir)
						song.item.move_mp3_to_normalized_file_path
						lio.put_line (" relocated to Music Extra")
					end
				end
				Database.archive_playlist.wipe_out
				Database.archive_playlist.extend (silence_1_sec)
				Database.store_all
			end
		end

feature {NONE} -- Implementation

	error_check
		do
			error_message.wipe_out
			if not archive_dir.exists then
				error_message := "Use 'archive-dir' in the task configuration to specify the archive directory"
			end
		end

end
