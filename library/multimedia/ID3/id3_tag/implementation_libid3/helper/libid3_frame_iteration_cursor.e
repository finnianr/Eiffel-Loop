note
	description: "Libid3 frame iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	LIBID3_FRAME_ITERATION_CURSOR

inherit
	EL_CPP_ITERATION_CURSOR [LIBID3_FRAME]
		rename
			cpp_next as cpp_iterator_next
		end

	LIBID3_ID3_TAG_ITERATOR_CPP_API

	ID3_MODULE_TAG

create
	make

feature -- Access

	item: LIBID3_FRAME
		local
			code: STRING
		do
			create code.make_from_c ({LIBID3_ID3_FRAME_CPP_API}.cpp_id (cpp_item))
			if code ~ Tag.Unique_file_id then
				create {LIBID3_UNIQUE_FILE_ID_FRAME} Result.make_from_pointer (cpp_item)
			elseif code ~ Tag.Album_picture then
				create {LIBID3_ALBUM_PICTURE_FRAME} Result.make_from_pointer (cpp_item)
			else
				create Result.make_from_pointer (cpp_item)
			end
		end

end