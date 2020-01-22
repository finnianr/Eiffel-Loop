note
	description: "[
		Interface to class `TagLib::ID3v2::TextIdentificationFrame'
		
			#include mpeg/id3v2/frames/textidentificationframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-22 10:26:36 GMT (Wednesday 22nd January 2020)"
	revision: "4"

class
	TL_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_conforms (frame: POINTER): BOOLEAN
		-- True if frame conforms to type `TagLib::ID3v2::TextIdentificationFrame'
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"[
				const TagLib::ID3v2::Frame* frame = (const TagLib::ID3v2::Frame*)$frame;
				return dynamic_cast<const TagLib::ID3v2::TextIdentificationFrame*>(frame) != NULL
			]"
		end

	frozen cpp_field_list (self: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/frames/textidentificationframe.h>"
		alias
			"new TagLib::StringList (((TagLib::ID3v2::TextIdentificationFrame*)$self)->fieldList ())"
		end

end
