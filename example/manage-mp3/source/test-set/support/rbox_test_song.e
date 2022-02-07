note
	description: "Rbox test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:26:27 GMT (Monday 7th February 2022)"
	revision: "5"

class
	RBOX_TEST_SONG

inherit
	RBOX_SONG
		redefine
			update_file_info
		end

create
	make

feature -- Element change

	update_file_info
		do
			file_size := File.byte_count (mp3_path)
		end

end