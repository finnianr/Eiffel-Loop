note
	description: "[
		Wrapper for ID3 tag editing library libid3 from id3lib.org

		Read and writes ID3 version 2.3. Does not seem to read earlier 2.x versions.
		Useful for reading/writing ID3 tags version <= 2.3
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 10:08:34 GMT (Saturday   26th   October   2019)"
	revision: "5"

class
	LIBID3_TAG_INFO

inherit
	ID3_INFO_I

	EL_OWNED_CPP_OBJECT
		export
			{LIBID3_TAG_INFO} self_ptr
		undefine
			default_create
		end

	LIBID3_ID3_TAG_CPP_API
		undefine
			default_create
		end

	LIBID3_CONSTANTS
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

	new_field (a_code: STRING): LIBID3_FRAME
			--
		do
			create Result.make_new (a_code)
			attach (Result)
		end

	new_unique_file_id_field (owner_id: ZSTRING; an_id: STRING): LIBID3_UNIQUE_FILE_ID_FRAME
			--
		do
			create Result.make (owner_id, an_id)
			attach (Result)
		end

	new_album_picture_frame (a_picture: ID3_ALBUM_PICTURE): LIBID3_ALBUM_PICTURE_FRAME
		do
			create Result.make (a_picture)
			attach (Result)
		end

feature {NONE} -- Implementation

	new_frame_list: EL_ARRAYED_LIST [LIBID3_FRAME]
		local
			iterator: LIBID3_FRAME_ITERATOR
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
			file_path: STRING
			to_c: ANY
		do
			file_path := mp3_path.to_string.to_utf_8
			to_c := file_path.to_c
			cpp_link (self_ptr, $to_c, tag_types)
		end

	is_c_call_ok: BOOLEAN

	update_flags: INTEGER

	c_call_status: INTEGER

feature -- Constants

	Days_in_year: INTEGER = 365

end
