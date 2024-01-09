note
	description: "[
		Interface to `TagLib::ID3v2::Header'
		
			#include mpeg/id3v2/id3v2header.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:21:25 GMT (Sunday 7th January 2024)"
	revision: "6"

class
	TL_ID3_V2_HEADER_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Access

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

feature {NONE} -- Measurement

	frozen cpp_complete_tag_size (self_ptr: POINTER): INTEGER
		--	unsigned int Header::completeTagSize()
		external
			"C++ [TagLib::ID3v2::Header %"mpeg/id3v2/id3v2header.h%"] (): EIF_INTEGER"
		alias
			"completeTagSize"
		end

	frozen cpp_tag_size (self_ptr: POINTER): INTEGER
		--	unsigned int tagSize()
		external
			"C++ [TagLib::ID3v2::Header %"mpeg/id3v2/id3v2header.h%"] (): EIF_INTEGER"
		alias
			"tagSize"
		end
end