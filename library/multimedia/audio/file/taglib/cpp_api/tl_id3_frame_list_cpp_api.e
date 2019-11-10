note
	description: "Interface to class `TagLib::ID3v2::FrameList'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:42:42 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	TL_ID3_FRAME_LIST_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Externals

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::ID3v2::FrameList %"mpeg/id3v2/id3v2tag.h%"] ()"
		end

	frozen cpp_iterator_begin (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::FrameList*)$self)->begin())"
		end

	frozen cpp_iterator_end (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::ID3v2::FrameList::ConstIterator (((TagLib::ID3v2::FrameList*)$self)->end())"
		end

end
