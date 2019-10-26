note
	description: "Interface to `TagLib::ID3v2::Header' in `mpeg/id3v2/id3v2header.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 17:26:00 GMT (Saturday   26th   October   2019)"
	revision: "1"

class
	TL_ID3_V2_HEADER_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_major_version (self_ptr: POINTER): INTEGER
		--	unsigned int majorVersion()
		external
			"C++ [TagLib::ID3v2::Header %"mpeg/id3v2/id3v2header.h%"] (): EIF_INTEGER"
		alias
			"majorVersion"
		end

	frozen cpp_revision_number (self_ptr: POINTER): INTEGER
		--	unsigned int revisionNumber()
		external
			"C++ [TagLib::ID3v2::Header %"mpeg/id3v2/id3v2header.h%"] (): EIF_INTEGER"
		alias
			"revisionNumber"
		end

	frozen cpp_tag_size (self_ptr: POINTER): INTEGER
		--	unsigned int tagSize()
		external
			"C++ [TagLib::ID3v2::Header %"mpeg/id3v2/id3v2header.h%"] (): EIF_INTEGER"
		alias
			"tagSize"
		end
end
