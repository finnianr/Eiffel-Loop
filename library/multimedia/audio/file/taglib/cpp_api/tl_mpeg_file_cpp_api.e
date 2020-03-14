note
	description: "[
		Interface to class `TagLib::MPEG::File'
		
			#include mpeg/mpegfile.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 14:20:54 GMT (Saturday 14th March 2020)"
	revision: "8"

class
	TL_MPEG_FILE_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

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

feature {NONE} -- Disposal

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::MPEG::File %"mpeg/mpegfile.h%"] ()"
		end

feature {NONE} -- Basic operations

	frozen cpp_save (self_ptr: POINTER): BOOLEAN
		-- Save the file.  If at least one tag -- ID3v1 or ID3v2 -- exists this
		-- will duplicate its content into the other tag.  This returns true
		-- if saving was successful.
		-- If neither exists or if both tags are empty, this will strip the tags
		-- from the file.
		-- This is the same as calling save(AllTags);

		--	virtual bool save();
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (): EIF_BOOLEAN"
		alias
			"save"
		end

feature {NONE} -- Status query

	frozen cpp_has_ID3_v1_tag (self_ptr: POINTER): BOOLEAN
		--	bool hasID3v2Tag()
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (): EIF_BOOLEAN"
		alias
			"hasID3v1Tag"
		end

	frozen cpp_has_ID3_v2_tag (self_ptr: POINTER): BOOLEAN
		--	bool hasID3v2Tag()
		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (): EIF_BOOLEAN"
		alias
			"hasID3v2Tag"
		end

feature {NONE} -- Access

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

end
