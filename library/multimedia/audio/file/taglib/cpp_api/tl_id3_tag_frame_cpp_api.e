note
	description: "[
		Interface to class `TagLib::ID3v2::Frame' defined in `mpeg/id3v2/id3v2frame.h'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:57:32 GMT (Thursday   31st   October   2019)"
	revision: "2"

class
	TL_ID3_TAG_FRAME_CPP_API

inherit
	EL_CPP_API

feature {TL_ID3_FRAME_LIST_ITERATOR_CPP_API} -- C++ Externals

	frozen cpp_frame_id (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"new TagLib::ByteVector (((TagLib::ID3v2::Frame*)$self)->frameID ())"
		end

	frozen cpp_to_string (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2frame.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Frame*)$self)->toString ())"
		end

end
