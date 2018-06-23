note
	description: "Rbox cortina test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-18 12:06:53 GMT (Monday 18th June 2018)"
	revision: "1"

class
	RBOX_CORTINA_TEST_SONG

inherit
	RBOX_CORTINA_SONG
		undefine
			update_file_info
		end

	RBOX_TEST_SONG
		rename
			make as make_song
		end

create
	make
end
