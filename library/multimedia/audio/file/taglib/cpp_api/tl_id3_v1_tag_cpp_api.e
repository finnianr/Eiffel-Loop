note
	description: "Interface to class `TagLib::ID3v1::Tag'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:17:28 GMT (Monday   28th   October   2019)"
	revision: "3"

class
	TL_ID3_V1_TAG_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_album (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v1::Tag*)$tag)->album ())"
		end

	frozen cpp_artist (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v1::Tag*)$tag)->artist ())"
		end

	frozen cpp_comment (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v1::Tag*)$tag)->comment ())"
		end

	frozen cpp_title (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v1/id3v1tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v1::Tag*)$tag)->title ())"
		end
end
