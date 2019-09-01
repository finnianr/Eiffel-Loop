note
	description: "Remove unknown album pictures task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:24:01 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	REMOVE_UNKNOWN_ALBUM_PICTURES_TASK

inherit
	MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.for_all_songs (
				not song_is_hidden and song_has_unknown_artist_and_album, agent Database.remove_unknown_album_picture
			)
			Database.store_all
			log.exit
		end

end
