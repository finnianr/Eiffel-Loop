note
	description: "Interface to class ID3_Frame::Iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 13:10:35 GMT (Monday 7th October 2019)"
	revision: "1"

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
