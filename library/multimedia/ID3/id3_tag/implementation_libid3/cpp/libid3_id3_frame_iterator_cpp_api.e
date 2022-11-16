note
	description: "Interface to class ID3_Frame::Iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	LIBID3_ID3_FRAME_ITERATOR_CPP_API

inherit
	LIBID3_CPP_API

feature {NONE} -- C++ Externals

	cpp_delete (self: POINTER)
			--
		external
			"C++ [delete ID3_Frame::Iterator %"id3/tag.h%"] ()"
		end

	cpp_iterator_next (iterator: POINTER): POINTER
			--
		external
			"C++ [ID3_Frame::Iterator %"id3/tag.h%"]: EIF_POINTER ()"
		alias
			"GetNext"
		end
end