note
	description: "Rbox test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

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
			file_size := File_system.file_byte_count (mp3_path)
		end

end
