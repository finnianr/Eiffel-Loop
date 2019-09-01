note
	description: "Display songs with incomplete TXXX ID3 tags"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:24:47 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	DISPLAY_INCOMPLETE_ID3_INFO_TASK

inherit
	MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
			-- Display songs with incomplete TXXX ID3 tags
		do
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent Database.display_incomplete_id3_info)
			log.exit
		end

end
