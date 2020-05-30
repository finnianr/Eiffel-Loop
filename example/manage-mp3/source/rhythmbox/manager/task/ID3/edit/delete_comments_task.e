note
	description: "Delete comments task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-30 11:42:26 GMT (Saturday 30th May 2020)"
	revision: "5"

class
	DELETE_COMMENTS_TASK

inherit
	ID3_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
		-- Delete comments except 'c0'
		do
			Database.for_all_songs_id3_info (any_song, agent delete_id3_comments)
			Database.store_all
		end

end
