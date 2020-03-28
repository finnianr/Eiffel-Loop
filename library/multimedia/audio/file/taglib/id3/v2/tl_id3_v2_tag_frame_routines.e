note
	description: "Tl id3 v2 tag frame routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 15:29:55 GMT (Friday 27th March 2020)"
	revision: "2"

deferred class
	TL_ID3_V2_TAG_FRAME_ROUTINES

inherit
	TL_ID3_V2_TAG_CPP_API

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_ONCE_STRING

feature -- Status query

	has_frame (a_frame_id: NATURAL_8): BOOLEAN
		do
			Result := first_frame (a_frame_id) /= Default_frame
		end

feature -- Measurement

	frame_count: INTEGER
		-- count of all frames
		do
			Result := cpp_frame_count (self_ptr)
		end

	frame_type_count (a_frame_id: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (a_frame_id)
		do
			across frame_list (a_frame_id) as frame loop
				Result := Result + 1
			end
		end

feature -- Access

	all_frames_list: EL_ARRAYED_LIST [TL_ID3_TAG_FRAME]
		do
			create Result.make (frame_count)
			across iterable_frames as frame loop
				Result.extend (frame.item)
			end
		end

	frame_integer (a_frame_id: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (a_frame_id)
		do
			Result := filled_once_string (a_frame_id).to_integer
		end

	frame_text (a_frame_id: NATURAL_8): ZSTRING
		require
			valid_code: valid_frame_id (a_frame_id)
		do
			Result := filled_once_string (a_frame_id).to_string
		end

	user_text_frame_list: EL_ARRAYED_LIST [TL_USER_TEXT_IDENTIFICATION_ID3_FRAME]
		do
			create Result.make (3)
			across frame_list (Frame_id.TXXX) as user loop
				if attached {TL_USER_TEXT_IDENTIFICATION_ID3_FRAME} user.item as frame then
					Result.extend (frame)
				end
			end
		end

feature -- Element change

	set_frame_integer_value (a_frame_id: NATURAL_8; n: INTEGER)
		do
			set_frame (a_frame_id, n)
		ensure
			set: frame_integer (a_frame_id) = n
		end

	set_frame_text (a_frame_id: NATURAL_8; text: READABLE_STRING_GENERAL)
		do
			set_frame (a_frame_id, text)
		ensure
			set: frame_text (a_frame_id).same_string (text)
		end

feature -- Removal

	remove_all (a_frame_id: NATURAL_8)
		-- remove all frames with `a_frame_id'
		do
			Once_byte_vector.set_data_from_string (Frame_id.name (a_frame_id))
			cpp_remove_frames (self_ptr, Once_byte_vector.self_ptr)
		end

feature {NONE} -- Implementation

	add_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_add_frame (self_ptr, frame.self_ptr)
		end

	filled_once_string (a_frame_id: NATURAL_8): like Once_string
		local
			id: like Once_byte_vector
		do
			Result := Once_string
			id := Once_byte_vector; id.set_from_frame_id (a_frame_id)
			cpp_get_first_frame_text (self_ptr, id.self_ptr, Result.self_ptr)
		end

	first_frame (a_frame_id: NATURAL_8): TL_ID3_TAG_FRAME
		require
			valid_code: valid_frame_id (a_frame_id)
		local
			cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			cursor := frame_list (a_frame_id).new_cursor
			if cursor.after then
				Result := Default_frame
			else
				Result := cursor.item
			end
		end

	frame_list (a_frame_id: NATURAL_8): TL_ID3_FRAME_LIST
		require
			valid_code: valid_frame_id (a_frame_id)
		local
			id: like Once_byte_vector
		do
			id := Once_byte_vector; id.set_from_frame_id (a_frame_id)
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

	remove_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_remove_frame (self_ptr, frame.self_ptr, True)
		end

	set_frame (a_frame_id: NATURAL_8; value: ANY)
		require
			valid_code: valid_frame_id (a_frame_id)
		local
			frame: TL_TEXT_IDENTIFICATION_ID3_FRAME
		do
			if attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} first_frame (a_frame_id) as first then
				frame := first
			else
				create frame.make (a_frame_id, text_encoding)
				add_frame (frame)
			end
			if attached {READABLE_STRING_GENERAL} value as general then
				frame.set_text (general)
			elseif attached {INTEGER} value as n then
				frame.set_integer_value (n)
			end
		end

	shared_user_text_list (a_description: READABLE_STRING_GENERAL): like Once_user_text_list
		-- shared user text list `Once_user_text_list'
		do
			Result := Once_user_text_list
			Result.wipe_out
			if User_text_table.has_key (self_ptr, a_description) then
				User_text_table.found_item.fill (Result)
			end
		end

feature {NONE} -- deferred attributes

	self_ptr: POINTER
		deferred
		end

	text_encoding: NATURAL_8
		-- the text encoding to be used when creating new frames
		deferred
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

	Once_user_text_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	User_text_table: TL_USER_TEXT_FRAME_TABLE
		once
			create Result
		end

end
