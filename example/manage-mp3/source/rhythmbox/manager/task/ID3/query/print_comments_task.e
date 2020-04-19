note
	description: "Print ID3 comments task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 9:14:42 GMT (Sunday 19th April 2020)"
	revision: "4"

class
	PRINT_COMMENTS_TASK

inherit
	ID3_TASK

create
	make

feature -- Basic operations

	apply
		do
			Database.for_all_songs_id3_info (not song_is_hidden, agent print_id3_comments)
		end

end
