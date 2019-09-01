note
	description: "Delete comments task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:24:55 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	DELETE_COMMENTS_TASK

inherit
	MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
			-- Delete comments except 'c0'
		do
			log.enter ("apply")
			Database.for_all_songs_id3_info (not song_is_hidden, agent Database.delete_id3_comments)
			Database.store_all
			log.exit
		end

end
