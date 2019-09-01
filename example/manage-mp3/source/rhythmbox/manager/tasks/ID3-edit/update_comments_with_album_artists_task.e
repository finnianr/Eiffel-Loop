note
	description: "Update comments with album artists task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:23:44 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK

inherit
	MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent Database.update_song_comment_with_album_artists)
			Database.store_all
			log.exit
		end

end
