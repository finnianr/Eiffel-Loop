note
	description: "Display songs with incomplete TXXX ID3 tags"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 15:17:19 GMT (Tuesday   8th   October   2019)"
	revision: "3"

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
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent display_incomplete_id3_info)
			log.exit
		end

feature {NONE} -- Implementation

	display_incomplete_id3_info (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			-- Display songs with incomplete TXXX ID3 tags
		do
			if across id3_info.user_text_table as user_text
				some
					user_text.item.description.is_empty and then user_text.item.string.is_integer
				end
			then
				print_id3 (id3_info, relative_song_path)
			end
		end

end
