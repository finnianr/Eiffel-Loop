note
	description: "Summary description for {RBOX_TEST_SONG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 13:04:46 GMT (Tuesday 15th December 2015)"
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
			file_size := File_system.file_byte_count (mp3_path)
		end

end