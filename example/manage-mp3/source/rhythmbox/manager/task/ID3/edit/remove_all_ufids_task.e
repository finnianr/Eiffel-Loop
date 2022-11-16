note
	description: "Remove all UFID's task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	REMOVE_ALL_UFIDS_TASK

inherit
	ID3_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
			--
		do
			Database.for_all_songs (any_song, agent remove_ufid)
			Database.store_all
		end

feature {NONE} -- Implementation

	remove_ufid (song: RBOX_SONG; relative_song_path: FILE_PATH; id3_info: TL_MPEG_FILE)
			--
		do
			if id3_info.tag.has_unique_id then
				print_id3 (id3_info, relative_song_path)
				id3_info.tag.remove_all_unique_ids
				id3_info.save
			end
		end

end