note
	description: "[
		Rename 'Comment' comments as 'c0'
		This is an antidote to a bug in Rhythmbox version 2.97 where editions to
		'c0' command are saved as 'Comment' and are no longer visible on reload.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 9:15:03 GMT (Sunday 19th April 2020)"
	revision: "5"

class
	NORMALIZE_COMMENTS_TASK

inherit
	ID3_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
		do
			Database.for_all_songs_id3_info (not song_is_hidden, agent normalize_comment)
			Database.store_all
		end

end
