note
	description: "Remove all UFID's task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-30 11:39:24 GMT (Saturday 30th May 2020)"
	revision: "9"

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

	remove_ufid (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: TL_MPEG_FILE)
			--
		do
			if id3_info.tag.has_unique_id then
				print_id3 (id3_info, relative_song_path)
				id3_info.tag.remove_all_unique_ids
				id3_info.save
			end
		end

end
