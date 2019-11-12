note
	description: "[
		Interface to class `TagLib::ID3v2::AttachedPictureFrame'
		
			#include mpeg/id3v2/frames/attachedpictureframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 14:37:32 GMT (Tuesday 12th November 2019)"
	revision: "3"

class
	TL_PICTURE_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::AttachedPictureFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/attachedpictureframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::AttachedPictureFrame*>(frame) != NULL
			]"
		end

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
