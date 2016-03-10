note
	description: "Summary description for {PLAYLIST_SONG_QUERY_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYLIST_MEMBER_QUERY_CONDITION

inherit
	EL_QUERY_CONDITION [RBOX_SONG]

create
	make

feature {NONE} -- Initialization

	make (database: RBOX_DATABASE)
		do
			create hash_set.make (database.playlists.count * 30)
			across database.playlists as playlist loop
				across playlist.item as song loop
					if not song.item.is_hidden then
						hash_set.put (song.item)
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

feature {NONE} -- Implementation

	hash_set: EL_HASH_SET [RBOX_SONG]
end
