note
	description: "Libid3 frame iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 9:56:14 GMT (Tuesday   8th   October   2019)"
	revision: "6"

class
	LIBID3_FRAME_ITERATOR

inherit
	EL_CPP_ITERATOR [LIBID3_FRAME]
		redefine
			new_item
		end

	LIBID3_ID3_TAG_ITERATOR_CPP_API

	ID3_MODULE_TAG

create
	make

feature {NONE} -- Implementation

	new_item: LIBID3_FRAME
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
