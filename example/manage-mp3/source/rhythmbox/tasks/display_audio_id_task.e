note
	description: "Display audio ID from Rhythmbox read from MP3 files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 8:34:42 GMT (Monday 30th March 2020)"
	revision: "1"

class
	DISPLAY_AUDIO_ID_TASK

inherit
	RBOX_MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		local
			mp3: MP3_IDENTIFIER
		do
			log.enter ("apply")
			across Database.songs.query (not song_is_hidden) as song loop
				create mp3.make (song.item.mp3_path)
				lio.put_labeled_string (song.item.title, mp3.audio_id.out)
				lio.put_new_line
			end
			log.exit
		end

end
