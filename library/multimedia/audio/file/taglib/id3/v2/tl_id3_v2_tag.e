note
	description: "ID3 ver. 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:33:45 GMT (Sunday 10th November 2019)"
	revision: "6"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG
		redefine
			make
		end

	TL_ID3_V2_TAG_CPP_API

	TL_SHARED_FRAME_CODE
		export
			{ANY} Frame_code
		end

create
	make

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
		do
			Precursor (a_ptr)
			create code_table.make (frame_count)
			across iterable_frame_code_list as code loop
				if code_table.has_key (code.item) then
					code_table [code.item] := code_table.found_item + 1
				else
					code_table.extend (1, code.item)
				end
			end
		end

feature -- Access

	all_frames_list: EL_ARRAYED_LIST [TL_ID3_TAG_FRAME]
		do
			create Result.make (frame_count)
			across iterable_frame_list as frame loop
				Result.extend (frame.item)
			end
		end

	frame_count: INTEGER
		-- count of all frames
		do
			Result := cpp_frame_count (self_ptr)
		end

	frame_list (code: NATURAL_8): TL_ID3_FRAME_LIST
		require
			valid_code: Frame_code.is_valid_value (code)
		local
			l_code: like Once_code
		do
			l_code := Once_code
			l_code.set_data (Frame_code.name (code))
			create Result.make (cpp_frame_list (self_ptr, l_code.self_ptr))
		end

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

feature {NONE} -- Implementation

	iterable_frame_code_list: TL_ID3_FRAME_CODE_LIST
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	iterable_frame_list: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

feature {NONE} -- Internal attributes

	code_table: HASH_TABLE [INTEGER, NATURAL_8]
		-- map ID3 frame code to count of occurrences of that frame code

feature {NONE} -- Constants

	Once_code: TL_BYTE_VECTOR
		once
			create Result.make_empty
		end

end
