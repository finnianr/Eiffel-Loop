note
	description: "[
		Interface to class `TagLib::ID3v2::CommentsFrame'
		
			#include mpeg/id3v2/frames/commentsframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 14:37:20 GMT (Tuesday 12th November 2019)"
	revision: "3"

class
	TL_COMMENTS_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::CommentsFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/commentsframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::CommentsFrame*>(frame) != NULL
			]"
		end

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
