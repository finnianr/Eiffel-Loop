note
	description: "Libid3 frame iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_LIBID3_FRAME_ITERATOR

inherit
	EL_CPP_ITERATOR [EL_LIBID3_FRAME]
		redefine
			new_item
		end

	EL_MODULE_TAG

create
	make

feature {NONE} -- Implementation

	new_item: EL_LIBID3_FRAME
		do
			Result := Precursor
			if Result.code ~ Tag.Unique_file_id then
				create {EL_LIBID3_UNIQUE_FILE_ID} Result.make_from_pointer (cpp_item)
			elseif Result.code ~ Tag.Album_picture then
				create {EL_ALBUM_PICTURE_LIBID3_FRAME} Result.make_from_pointer (cpp_item)
			end
		end

feature {NONE} -- Externals

	cpp_delete (self: POINTER)
			--
		external
			"C++ [delete ID3_Tag::Iterator %"id3/tag.h%"] ()"
		end

	cpp_iterator_next (iterator: POINTER): POINTER
			--
		external
			"C++ [ID3_Tag::Iterator %"id3/tag.h%"]: EIF_POINTER ()"
		alias
			"GetNext"
		end

end
