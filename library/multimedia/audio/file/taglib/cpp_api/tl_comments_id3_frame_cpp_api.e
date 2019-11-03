note
	description: "[
		Interface to class `TagLib::ID3v2::CommentsFrame'
		
			#include mpeg/id3v2/frames/commentsframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:56:10 GMT (Thursday 31st October 2019)"
	revision: "1"

class
	TL_COMMENTS_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_description (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::CommentsFrame*)$self)->description ())"
		end

	frozen cpp_language (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"new TagLib::ByteVector (((TagLib::ID3v2::CommentsFrame*)$self)->language ())"
		end

end
