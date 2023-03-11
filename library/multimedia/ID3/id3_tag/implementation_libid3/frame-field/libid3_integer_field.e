note
	description: "Libid3 integer field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "3"

class
	LIBID3_INTEGER_FIELD

inherit
	ID3_INTEGER_FIELD

	LIBID3_FRAME_FIELD

create
	make

feature -- Access

	integer: INTEGER
		do
			Result := cpp_integer (self_ptr)
		end

feature -- Element change

	set_integer (value: INTEGER)
			--
		do
			cpp_set_integer (self_ptr, value)
		end

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := <<
				FN_content_type, FN_counter, FN_id, FN_picture_type, FN_time_stamp_format, FN_rating, FN_volume_adjust,
				FN_numbits, FN_volume_change_right, FN_volume_change_left, FN_peak_volume_left, FN_peak_volume_right
			>>
		end

end