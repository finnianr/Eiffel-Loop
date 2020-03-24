note
	description: "Remove all ufids task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 14:10:45 GMT (Tuesday 24th March 2020)"
	revision: "5"

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
