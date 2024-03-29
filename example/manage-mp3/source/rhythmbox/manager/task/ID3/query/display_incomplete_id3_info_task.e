note
	description: "Display songs with incomplete TXXX ID3 tags"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	DISPLAY_INCOMPLETE_ID3_INFO_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
			-- Display songs with incomplete TXXX ID3 tags
		do
			Database.for_all_songs (any_song, agent display_incomplete_id3_info)
		end

feature {NONE} -- Implementation

	display_incomplete_id3_info (song: RBOX_SONG; relative_song_path: FILE_PATH; id3_info: TL_MPEG_FILE)
			-- Display songs with incomplete TXXX ID3 tags
		do
			if across id3_info.tag.user_text_frame_list as user
				some
					user.item.description.is_empty and then user.item.text.is_integer
				end
			then
				print_id3 (id3_info, relative_song_path)
			end
		end

end