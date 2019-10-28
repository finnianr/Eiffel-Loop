note
	description: "Interface to class `TagLib::ID3v2::Tag'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:17:42 GMT (Monday   28th   October   2019)"
	revision: "3"

class
	TL_ID3_V2_TAG_CPP_API

inherit
	EL_POINTER_ROUTINES
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- C++ Externals

	frozen cpp_album (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Tag*)$tag)->album ())"
		end

	frozen cpp_artist (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Tag*)$tag)->artist ())"
		end

	frozen cpp_comment (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Tag*)$tag)->comment ())"
		end

	frozen cpp_header (self_ptr: POINTER): POINTER
		--	Header *header()
		external
			"C++ [TagLib::ID3v2::Tag %"mpeg/id3v2/id3v2tag.h%"] (): EIF_POINTER"
		alias
			"header"
		end

	frozen cpp_title (tag: POINTER): POINTER
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"new TagLib::String (((TagLib::ID3v2::Tag*)$tag)->title ())"
		end

end
