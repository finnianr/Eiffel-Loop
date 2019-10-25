note
	description: "Interface to class ID3_Tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 13:26:03 GMT (Monday   7th   October   2019)"
	revision: "1"

class
	LIBID3_ID3_TAG_CPP_API

inherit
	LIBID3_CPP_API

feature {NONE} -- C++ Externals: Basic operations

	cpp_new: POINTER
			--
		external
			"C++ [new ID3_Tag %"id3/tag.h%"] ()"
		end

	cpp_delete (self: POINTER)
			--
		external
			"C++ [delete ID3_Tag %"id3/tag.h%"] ()"
		end

	cpp_link (self, file_name: POINTER; flags: INTEGER)
			--
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (char*, flags_t)"
		alias
			"Link"
		end

feature {NONE} -- C++ Externals: Access

	cpp_iterator (self: POINTER): POINTER
			--
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_POINTER"
		alias
			"CreateIterator"
		end

	cpp_spec (self: POINTER): INTEGER
			--ID3_V2Spec GetSpec () const
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"GetSpec"
		end

	cpp_frame_count (self: POINTER): INTEGER
			-- size_t NumFrames () const
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"NumFrames"
		end

	cpp_has_v1_tag (self: POINTER): BOOLEAN
			-- bool ID3_Tag::HasV1Tag()
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_BOOLEAN"
		alias
			"HasV1Tag"
		end

	cpp_has_v2_tag (self: POINTER): BOOLEAN
			-- bool ID3_Tag::HasV2Tag()
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_BOOLEAN"
		alias
			"HasV2Tag"
		end

feature {NONE} -- C++ Externals: Element change

	cpp_set_spec (self: POINTER; spec_id: INTEGER): BOOLEAN
			-- bool ID3_Frame::SetSpec (ID3_V2Spec spec)
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (ID3_V2Spec): EIF_BOOLEAN"
		alias
			"SetSpec"
		end

	cpp_clear (self: POINTER)
			--
		external
			"C++ [ID3_Tag %"id3/tag.h%"] ()"
		alias
			"Clear"
		end

	cpp_update_version (self: POINTER; flags: INTEGER): INTEGER
			-- flags_t ID3_Tag::Update(flags_t flags)
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (flags_t): EIF_INTEGER"
		alias
			"Update"
		end

	cpp_update (self: POINTER): INTEGER
			-- flags_t ID3_Tag::Update(flags_t flags)
		external
			"C++ [ID3_Tag %"id3/tag.h%"]: EIF_INTEGER"
		alias
			"Update"
		end

	cpp_strip (self: POINTER; flags: INTEGER)
			--  flags_t ID3_Tag::Strip (flags_t flags = (flags_t) ID3TT_ALL )
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (flags_t)"
		alias
			"Strip"
		end

	cpp_attach_frame (self, frame_ptr: POINTER)
			--  void ID3_Tag::AttachFrame (ID3_Frame * frame )
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (ID3_Frame *)"
		alias
			"AttachFrame"
		end

	cpp_remove_frame (self, frame_ptr: POINTER): POINTER
			--  ID3_Frame* ID3_Tag::RemoveFrame(const ID3_Frame *frame)
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (ID3_Frame *): EIF_POINTER"
		alias
			"RemoveFrame"
		end

	cpp_set_unsync (self: POINTER; flag: BOOLEAN): BOOLEAN
			--  bool ID3_Tag::SetUnsync (bool b )
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (bool): EIF_BOOLEAN"
		alias
			"SetUnsync"
		end

	cpp_set_padding (self: POINTER; flag: BOOLEAN): BOOLEAN
			--  bool ID3_Tag::SetUnsync (bool b )
		external
			"C++ [ID3_Tag %"id3/tag.h%"] (bool): EIF_BOOLEAN"
		alias
			"SetPadding"
		end

end
