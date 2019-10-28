note
	description: "Interface to `TagLib::MPEG::File' in `mpeg/mpegfile.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 10:29:14 GMT (Sunday   27th   October   2019)"
	revision: "3"

class
	TL_MPEG_FILE_CPP_API

inherit
	EL_POINTER_ROUTINES
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- C++ Externals

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::MPEG::File %"mpeg/mpegfile.h%"] ()"
		end

	frozen cpp_has_ID3_v2_tag (self_ptr: POINTER): BOOLEAN
		--	bool hasID3v2Tag()
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (): EIF_BOOLEAN"
		alias
			"hasID3v2Tag"
		end

	frozen cpp_has_ID3_v1_tag (self_ptr: POINTER): BOOLEAN
		--	bool hasID3v2Tag()
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (): EIF_BOOLEAN"
		alias
			"hasID3v1Tag"
		end

	frozen cpp_ID3_v1_tag (self_ptr: POINTER; create_tag: BOOLEAN): POINTER
		--	ID3v2::Tag *ID3v2Tag(bool create = false);
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (bool): EIF_POINTER"
		alias
			"ID3v1Tag"
		end
	frozen cpp_ID3_v2_tag (self_ptr: POINTER; create_tag: BOOLEAN): POINTER
		--	ID3v2::Tag *ID3v2Tag(bool create = false);
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (bool): EIF_POINTER"
		alias
			"ID3v2Tag"
		end

	frozen cpp_new (file_ptr: POINTER): POINTER
		--	File	(FileName file, bool readProperties = true,
		--			Properties::ReadStyle propertiesStyle = Properties::Average);
		require
			attached_pointer: is_attached (file_ptr)
		external
			"C++ inline use <mpeg/mpegfile.h>"
		alias
			"new TagLib::MPEG::File ((TagLib::FileName)$file_ptr)"
		end

end
