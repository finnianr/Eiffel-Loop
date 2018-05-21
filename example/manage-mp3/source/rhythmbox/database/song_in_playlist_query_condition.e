note
	description: "Song in playlist query condition"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	SONG_IN_PLAYLIST_QUERY_CONDITION

inherit
	EL_QUERY_CONDITION [RBOX_SONG]

create
	make, make_with_name

feature {NONE} -- Initialization

	make (database: RBOX_DATABASE)
		do
			make_with_name (All_lists, database)
		end

	make_with_name (playlist_name: ZSTRING; database: RBOX_DATABASE)
		do
			create hash_set.make (database.playlists.count * 30)
			create selected_playlists.make (database.playlists.count)
			across database.playlists as playlist loop
				if playlist_name /= All_lists implies playlist_name ~ playlist.item.name then
					selected_playlists.extend (playlist.item)
					across playlist.item as song loop
						if not song.item.is_hidden then
							hash_set.put (song.item)
						end
					end
				end
			end
			database.silence_intervals.do_all (agent hash_set.put)
		end

feature -- Access

	include (item: RBOX_SONG): BOOLEAN
		do
			Result := hash_set.has (item)
		end

	selected_playlists: EL_ARRAYED_LIST [RBOX_PLAYLIST]

feature {NONE} -- Implementation

	hash_set: EL_HASH_SET [RBOX_SONG]

feature {NONE} -- Constants

	All_lists: ZSTRING
		once
			Result := "*"
		end
end