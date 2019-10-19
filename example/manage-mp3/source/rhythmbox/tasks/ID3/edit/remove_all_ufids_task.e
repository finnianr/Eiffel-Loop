note
	description: "Remove all ufids task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 7:00:00 GMT (Thursday 5th September 2019)"
	revision: "2"

class
	REMOVE_ALL_UFIDS_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
			--
		do
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent remove_ufid)
			Database.store_all
			log.exit
		end

feature {NONE} -- Implementation

	remove_ufid (song: RBOX_SONG; relative_song_path: EL_FILE_PATH; id3_info: EL_ID3_INFO)
			--
		do
			if not id3_info.unique_id_list.is_empty then
				print_id3 (id3_info, relative_song_path)
				id3_info.remove_all_unique_ids
				id3_info.update
			end
		end

end
