note
	description: "[
		Interface to class `TagLib::ID3v2::PrivateFrame'

			#include mpeg/id3v2/frames/privateframe.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:21:44 GMT (Sunday 7th January 2024)"
	revision: "3"

class
	TL_ID3_PRIVATE_TAG_FRAME_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_new_empty: POINTER
		-- PrivateFrame();
		external
			"C++ [new TagLib::ID3v2::PrivateFrame %"mpeg/id3v2/frames/privateframe.h%"] ()"
		end

	frozen cpp_delete (self: POINTER)
		-- ~PrivateFrame();
		external
			"C++ [delete TagLib::ID3v2::PrivateFrame %"mpeg/id3v2/frames/privateframe.h%"] ()"
		end

end