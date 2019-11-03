note
	description: "[
		Interface to class `TagLib::ID3v2::AttachedPictureFrame'
		
			#include mpeg/id3v2/frames/attachedpictureframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:55:00 GMT (Thursday 31st October 2019)"
	revision: "1"

class
	TL_PICTURE_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_picture (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"new TagLib::ByteVector (((TagLib::ID3v2::AttachedPictureFrame*)$self)->picture ())"
		end

	frozen cpp_description (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::AttachedPictureFrame*)$self)->description ())"
		end

	frozen cpp_mime_type (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::AttachedPictureFrame*)$self)->mimeType ())"
		end

end
