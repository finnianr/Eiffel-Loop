note
	description: "[
		Wrapper for ID3 tag editing library libid3 from id3lib.org

		Read and writes ID3 version 2.3. Does not seem to read earlier 2.x versions.
		Useful for reading/writing ID3 tags version <= 2.3
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 14:33:23 GMT (Friday 1st July 2016)"
	revision: "7"

class
	EL_LIBID3_TAG_INFO

inherit
	EL_ID3_INFO_I
		export
			{EL_LIBID3_TAG_INFO} self_ptr
		redefine
			cpp_delete, is_memory_owned
		end

	EL_LIBID3_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature -- Initialization

	make
			--
		do
--			log.enter ("make")
			default_create
			make_from_pointer (cpp_new)
--			log.exit
		end

feature -- Access

	unique_id: INTEGER
			--
		do
		end

feature -- File writes

	update
			--
		do
			update_flags := cpp_update (self_ptr)
		end

	update_v2
			--
		do
			update_flags := cpp_update_version (self_ptr, ID3_v2)
		end

	update_v1
			--
		do
			update_flags := cpp_update_version (self_ptr, ID3_v1)
		end

	strip_v1
			--
		do
			cpp_strip (self_ptr, ID3_v1)
		end

	strip_v2
			--
		do
			cpp_strip (self_ptr, ID3_v2)
		end

feature {NONE} -- Removal

	wipe_out
			--
		do
			frame_list.wipe_out
			cpp_clear (self_ptr)
		end

	detach (field: like new_field)
			--
		local
			detached_ptr: POINTER
		do
			detached_ptr := cpp_remove_frame (self_ptr, field.self_ptr)
		end

feature -- Status setting

	set_unsync (flag: BOOLEAN)
			--
		do
			is_c_call_ok := cpp_set_unsync (self_ptr, flag)
		end

	set_padding (flag: BOOLEAN)
			--
		do
			is_c_call_ok := cpp_set_padding (self_ptr, flag)
		end

feature -- Element change

	set_version (a_version: REAL)
			--
		do
			inspect (a_version * 100).rounded
				when 100 then
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v1_0)

				when 110 then
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v1_1)

				when 221 then
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v2_21)

				when 220 then
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v2_2)

				when 230 then
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v2_3)

				else
					is_c_call_ok := cpp_set_spec (self_ptr, ID3v2_unknown)

			end
		end

	link_and_read (a_mp3_path: like mp3_path)
		do
			mp3_path := a_mp3_path
			wipe_out
			link_tags (ID3_v2)
			frame_list := new_frame_list
		end

	link (a_mp3_path: like mp3_path)
		-- link to a file without reading tags
		do
			mp3_path := a_mp3_path
			wipe_out
			link_tags (ID3_none)
		end

feature {NONE} -- Factory

	new_field (a_code: STRING): EL_LIBID3_FRAME
			--
		do
			create Result.make_with_code (a_code)
			attach (Result)
		end

	new_unique_file_id_field (owner_id: ZSTRING; an_id: STRING): EL_LIBID3_UNIQUE_FILE_ID
			--
		do
			create Result.make (owner_id, an_id)
			attach (Result)
		end

	new_album_picture_frame (a_picture: EL_ID3_ALBUM_PICTURE): EL_ALBUM_PICTURE_LIBID3_FRAME
		do
			create Result.make (a_picture)
			attach (Result)
		end

feature {NONE} -- Implementation

	new_frame_list: ARRAYED_LIST [EL_LIBID3_FRAME]
		local
			iterator: EL_LIBID3_FRAME_ITERATOR
		do
			create Result.make (frame_count)
			create iterator.make (agent new_frame_iterator)
			iterator.do_all (agent Result.extend)
		end

   frame_count: INTEGER
 		--
		do
			Result := cpp_frame_count (self_ptr)
		end

	new_frame_iterator: POINTER
			--
		do
			Result := cpp_iterator (self_ptr)
		end

	attach (field: like new_field)
			--
		do
			cpp_attach_frame (self_ptr, field.self_ptr)
			frame_list.extend (field)
		end

	link_tags (tag_types: INTEGER)
		local
			utf8_file_path: STRING
		do
			utf8_file_path := mp3_path.to_string.to_utf_8
			cpp_link (self_ptr, utf8_file_path.area.base_address, tag_types)
		end

   is_memory_owned: BOOLEAN = true

	is_c_call_ok: BOOLEAN

	update_flags: INTEGER

	c_call_status: INTEGER

feature -- Constants

	Days_in_year: INTEGER = 365

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