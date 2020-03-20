note
	description: "[
		Interface to class `TagLib::MPEG::File'
		
			#include mpeg/mpegfile.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-20 11:02:06 GMT (Friday 20th March 2020)"
	revision: "10"

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

	frozen cpp_save (self_ptr: POINTER; types: INTEGER): BOOLEAN
		--	bool save(int tags);

		-- Save the file.  This will attempt to save all of the tag types that are
		-- specified by OR-ing together TagTypes values.  The save() method above
		-- uses AllTags.  This returns true if saving was successful.

		-- This strips all tags not included in the mask, but does not modify them
		-- in memory, so later calls to save() which make use of these tags will
		-- remain valid.  This also strips empty tags.

		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (int): EIF_BOOLEAN"
		alias
			"save"
		end

	frozen cpp_save_version (self_ptr: POINTER; types: INTEGER; strip_others: BOOLEAN; id3_v2_version: INTEGER): BOOLEAN
		--	bool save(int tags, bool stripOthers, int id3v2Version);

		--	Save the file.  This will attempt to save all of the tag types that are
		--	specified by OR-ing together TagTypes values.  The save() method above
		--	uses AllTags.  This returns true if saving was successful.

		--	If stripOthers is true this strips all tags not included in the mask,
		--	but does not modify them in memory, so later calls to save() which make
		--	use of these tags will remain valid.  This also strips empty tags.

		--	The id3v2Version parameter specifies the version of the saved
		--	ID3v2 tag. It can be either 4 or 3.

		external
			"C++ [TagLib::MPEG::File %"mpeg/mpegfile.h%"] (int, bool, int): EIF_BOOLEAN"
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
