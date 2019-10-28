note
	description: "Interface to class `TagLib::ID3v2::Tag'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 17:00:29 GMT (Sunday   27th   October   2019)"
	revision: "2"

class
	TL_ID3_V2_TAG_CPP_API

inherit
	EL_POINTER_ROUTINES
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- C++ Externals

	frozen cpp_header (self_ptr: POINTER): POINTER
		--	Header *header()
		external
			"C++ [TagLib::ID3v2::Tag %"mpeg/id3v2/id3v2tag.h%"] (): EIF_POINTER"
		alias
			"header"
		end

	frozen cpp_copy_title (tag, string: POINTER)
		external
			"C++ inline use <mpeg/id3v2/id3v2tag.h>"
		alias
			"*((TagLib::String*)$string) = ((TagLib::ID3v2::Tag*)$tag)->title ()"
		end

end
