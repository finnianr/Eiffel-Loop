note
	description: "Print ID3 comments task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 14:20:29 GMT (Tuesday 31st March 2020)"
	revision: "3"

class
	PRINT_COMMENTS_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.for_all_songs_id3_info (not song_is_hidden, agent print_id3_comments)
			log.exit
		end

end
