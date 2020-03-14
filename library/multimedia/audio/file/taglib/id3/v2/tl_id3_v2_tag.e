note
	description: "ID3 ver. 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 19:07:31 GMT (Saturday 14th March 2020)"
	revision: "9"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG
		redefine
			make, header, picture
		end

	TL_ID3_V2_TAG_CPP_API

	TL_SHARED_FRAME_ID_ENUM
		export
			{ANY} Frame_id
		end

	TL_SHARED_BYTE_VECTOR

create
	make

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
		do
			Precursor (a_ptr)
			create frame_count_table.make (frame_count)
			across iterable_frame_codes as code loop
				if frame_count_table.has_key (code.item) then
					frame_count_table [code.item] := frame_count_table.found_item + 1
				else
					frame_count_table.extend (1, code.item)
				end
			end
		end

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

	title: ZSTRING
		do
			Result := frame_text (Frame_id.TIT2)
		end

	picture: TL_PICTURE_ID3_FRAME
		do
			if has_frame (Frame_id.apic) and then attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.apic) as frame then
				Result := frame
			else
				create Result
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

	frame_id_enum_list: ARRAY [NATURAL_8]
		-- list of frame id enumeration codes
		do
			Result := frame_count_table.current_keys
		end

	frame_text (enum_code: NATURAL_8): ZSTRING
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		do
			if frame_count_table.has (enum_code) then
				Result := filled_once_string (enum_code).to_string
			else
				create Result.make_empty
			end
		end

	frame_integer (enum_code: NATURAL_8): INTEGER
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		do
			if frame_count_table.has (enum_code) then
				Result := filled_once_string (enum_code).to_integer
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

feature -- Status query

	has_frame (enum_code: NATURAL_8): BOOLEAN
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		do
			Result := frame_count_table.has (enum_code)
		end

	has_multiple_frames (enum_code: NATURAL_8): BOOLEAN
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		do
			if frame_count_table.has_key (enum_code) then
				Result := frame_count_table.found_item > 1
			end
		end

	has_single_frame (enum_code: NATURAL_8): BOOLEAN
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		do
			if frame_count_table.has_key (enum_code) then
				Result := frame_count_table.found_item = 1
			end
		end

feature -- Element change

	set_picture (a_picture: TL_ID3_PICTURE)
		local
			l_frame: TL_PICTURE_ID3_FRAME
		do
			if has_frame (Frame_id.apic) and then attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.apic) as frame then
				cpp_remove_frame (self_ptr, frame.self_ptr)
			end
			create l_frame.make (a_picture.data, a_picture.description, a_picture.mime_type, a_picture.type_enum)
			cpp_add_frame (self_ptr, l_frame.self_ptr)
		end

feature -- Constants

	version: INTEGER = 2
		-- ID3 version number

feature {NONE} -- Implementation

	iterable_frame_codes: EL_CPP_STD_LIST [TL_ID3_FRAME_CODE_ITERATION_CURSOR, NATURAL_8]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	iterable_frames: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	filled_once_string (enum_code: NATURAL_8): like Once_string
		require
			has_field: frame_count_table.has (enum_code)
		local
			id: like Once_byte_vector
		do
			Result := Once_string
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			cpp_get_first_frame_text (self_ptr, id.self_ptr, Result.self_ptr)
		end

	first_frame (enum_code: NATURAL_8): TL_ID3_TAG_FRAME
		require
			has_frame: has_frame (enum_code)
			valid_code: Frame_id.is_valid_value (enum_code)
		local
			cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			cursor := frame_list (enum_code).new_cursor
			if cursor.after then
				create Result
			else
				Result := cursor.item
			end
		end

	frame_list (enum_code: NATURAL_8): TL_ID3_FRAME_LIST
		require
			valid_code: Frame_id.is_valid_value (enum_code)
		local
			id: like Once_byte_vector
		do
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			Result := Once_frame_list
			Result.set_from_pointer (cpp_frame_list (self_ptr, id.self_ptr))
		end

feature {NONE} -- Internal attributes

	frame_count_table: HASH_TABLE [INTEGER, NATURAL_8]
		-- map ID3 frame enum_code to count of occurrences of that frame code

	Once_frame_list: TL_ID3_FRAME_LIST
		once
			create Result
		end

end
