note
	description: "Display music brainz info task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 6:57:30 GMT (Thursday 5th September 2019)"
	revision: "2"

class
	DISPLAY_MUSIC_BRAINZ_INFO_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		local
			id3_info: EL_ID3_INFO
		do
			log.enter ("apply")
			across Database.songs.query (not song_has_audio_id) as song loop
				lio.put_path_field ("MP3", song.item.mp3_path)
				lio.put_new_line
				create id3_info.make (song.item.mp3_path)
				across id3_info.user_text_table as user_text loop
					lio.put_string_field (user_text.key, user_text.item.string)
					lio.put_new_line
				end
				lio.put_line ("UNIQUE IDs")
				across id3_info.unique_id_list as unique_id loop
					lio.put_string_field (unique_id.item.owner, unique_id.item.id)
					lio.put_new_line
				end
				lio.put_new_line
			end
			log.exit
		end

end
