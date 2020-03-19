note
	description: "ID3 version 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 16:55:28 GMT (Thursday 19th March 2020)"
	revision: "12"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG
		redefine
			header, picture, set_unique_id, unique_id_list, user_text_list, user_text,
			has_user_text, has_any_user_text, set_user_text
		end

	TL_ID3_V2_TAG_CPP_API

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_STRING_ENCODING_ENUM

	TL_SHARED_ONCE_STRING_LIST

create
	make

feature -- ID3 fields

	album: ZSTRING
		do
			Result := frame_text (Frame_id.TALB)
		end

	artist: ZSTRING
		do
			Result := frame_text (Frame_id.TPE1)
		end

	comment: ZSTRING
		do
			cpp_get_comment (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	duration: INTEGER
		do
			Result := frame_integer (Frame_id.TLEN)
		end

	picture: TL_ID3_PICTURE
		do
			if attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.apic) as frame then
				create Result.make_from_frame (frame)
			else
				create Result.make_default
			end
		end

	title: ZSTRING
		do
			Result := frame_text (Frame_id.TIT2)
		end

	unique_id_list (owner: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [TL_UNIQUE_FILE_IDENTIFIER]
		-- unique identifier frames with owner equal to `owner'
		-- unless owner is the string `Empty_string' in which case all frames are added
		local
			found: BOOLEAN
		do
			create Result.make (2)
			across frame_list (Frame_id.UFID) as ufid until found loop
				if attached {TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME} ufid.item as ufid_frame then
					if owner = Empty_string then
						Result.extend (ufid_frame)

					elseif owner.same_string (ufid_frame.owner) then
						Result.extend (ufid_frame)
						found := True
					end
				end
			end
		end

feature -- Frames

	all_frames_list: EL_ARRAYED_LIST [TL_ID3_TAG_FRAME]
		do
			create Result.make (frame_count)
			across iterable_frames as frame loop
				Result.extend (frame.item)
			end
		end

	frame_integer (enum_code: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := filled_once_string (enum_code).to_integer
		end

	frame_text (enum_code: NATURAL_8): ZSTRING
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := filled_once_string (enum_code).to_string
		end

	user_text (a_description: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := user_text_list (a_description).joined_lines
		end

	user_text_list (a_description: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		local
			frame_ptr, description_ptr: POINTER
			frame: TL_USER_TEXT_IDENTIFICATION_ID3_FRAME
		do
			Once_string.set_from_string (a_description)
			description_ptr := Once_string.self_ptr
			frame_ptr := {TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API}.cpp_find_user_text_frame (self_ptr, description_ptr)
			if is_attached (frame_ptr) then
				create frame.make_from_pointer (frame_ptr)
				Result := frame.text_list
			else
				create Result.make_empty
			end
		end

feature -- Access

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

feature -- Measurement

	frame_count: INTEGER
		-- count of all frames
		do
			Result := cpp_frame_count (self_ptr)
		end

	frame_type_count (enum_code: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (enum_code)
		do
			across frame_list (enum_code) as frame loop
				Result := Result + 1
			end
		end

feature -- Status query

	has_frame (enum_code: NATURAL_8): BOOLEAN
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := first_frame (enum_code) /= Default_frame
		end

	has_user_text (a_description: READABLE_STRING_GENERAL): BOOLEAN
		local
			frame_ptr, description_ptr: POINTER
		do
			Once_string.set_from_string (a_description)
			description_ptr := Once_string.self_ptr
			frame_ptr := {TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API}.cpp_find_user_text_frame (self_ptr, description_ptr)
			Result := is_attached (frame_ptr)
		end

	has_any_user_text: BOOLEAN
		do
			Result := frame_list (Frame_id.TXXX).count > 0
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TALB, a_album)
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TPE1, a_artist)
		end

	set_picture (a_picture: TL_ID3_PICTURE)
		do
			if attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.APIC) as l_frame then
				remove_frame (l_frame)
			end
			add_frame (a_picture.to_frame)
		ensure then
			set: picture ~ a_picture
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TIT2, a_title)
		end

	set_unique_id (owner: READABLE_STRING_GENERAL; identifier: STRING)
		local
			list: like unique_id_list
			ufid: TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME
		do
			list := unique_id_list (owner)
			if list.is_empty then
				create ufid.make (owner, identifier)
				add_frame (ufid)
			else
				list.first.set_identifier (identifier)
			end
		end

	set_user_text (a_description, a_text: READABLE_STRING_GENERAL)
		local
			frame_ptr, description_ptr: POINTER
			frame: TL_USER_TEXT_IDENTIFICATION_ID3_FRAME
		do
			Once_string.set_from_string (a_description)
			description_ptr := Once_string.self_ptr
			frame_ptr := {TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API}.cpp_find_user_text_frame (self_ptr, description_ptr)
			if is_attached (frame_ptr) then
				create frame.make_from_pointer (frame_ptr)
				frame.set_text (a_text)
			else
				create frame.make (a_description, a_text.split ('%N'), String_encoding.utf_16)
				add_frame (frame)
			end
		ensure then
			set: a_text.same_string (user_text (a_description))
		end

feature -- Removal

	remove_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_remove_frame (self_ptr, frame.self_ptr)
		end

	remove_unique_id (owner: READABLE_STRING_GENERAL)
		do
			across unique_id_list (owner) as ufid loop
				if attached {TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME} ufid.item as frame then
					remove_frame (frame)
				end
			end
		end

feature -- Constants

	Type: INTEGER = 2

	Version: INTEGER = 2
		-- ID3 version number

feature {NONE} -- Implementation

	add_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_add_frame (self_ptr, frame.self_ptr)
		end

	filled_once_string (enum_code: NATURAL_8): like Once_string
		local
			id: like Once_byte_vector
		do
			Result := Once_string
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			cpp_get_first_frame_text (self_ptr, id.self_ptr, Result.self_ptr)
		end

	first_frame (enum_code: NATURAL_8): TL_ID3_TAG_FRAME
		require
			valid_code: valid_frame_id (enum_code)
		local
			cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			cursor := frame_list (enum_code).new_cursor
			if cursor.after then
				Result := Default_frame
			else
				Result := cursor.item
			end
		end

	frame_list (enum_code: NATURAL_8): TL_ID3_FRAME_LIST
		require
			valid_code: valid_frame_id (enum_code)
		local
			id: like Once_byte_vector
		do
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			Result := Once_frame_list
			Result.set_from_pointer (cpp_frame_list (self_ptr, id.self_ptr))
		end

	iterable_frame_codes: EL_CPP_STD_LIST [TL_ID3_FRAME_CODE_ITERATION_CURSOR, NATURAL_8]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	iterable_frames: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	set_frame_text (enum_code: NATURAL_8; text: READABLE_STRING_GENERAL)
		require
			valid_code: valid_frame_id (enum_code)
		local
			frame: TL_TEXT_IDENTIFICATION_ID3_FRAME
		do
			if attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} first_frame (enum_code) as l_frame then
				l_frame.set_text (text)
			else
				create frame.make (enum_code, String_encoding.utf_16)
				frame.set_text (text)
				add_frame (frame)
			end
		ensure
			set: frame_text (enum_code).same_string (text)
		end

feature {NONE} -- Constants

	Default_frame: TL_DEFAULT_ID3_TAG_FRAME
		once
			create Result.make
		end

	Once_frame_list: TL_ID3_FRAME_LIST
		once
			create Result.make
		end

end
