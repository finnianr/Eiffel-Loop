note
	description: "Display music brainz info task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-21 8:57:22 GMT (Thursday 21st May 2020)"
	revision: "8"

class
	DISPLAY_MUSIC_BRAINZ_INFO_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		local
			id3_info: TL_MPEG_FILE
		do
			across Database.songs.query (not song_has_audio_id) as song loop
				lio.put_path_field ("MP3", song.item.mp3_path)
				lio.put_new_line
				create id3_info.make (song.item.mp3_path)
				across id3_info.tag.user_text_frame_list as user loop
					lio.put_string_field (user.item.description, user.item.text)
					lio.put_new_line
				end
				lio.put_line ("UNIQUE IDs")
				across id3_info.tag.unique_id_list as id loop
					lio.put_string_field (id.item.owner, id.item.identifier)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

end
