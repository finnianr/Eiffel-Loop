note
	description: "Rbox test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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