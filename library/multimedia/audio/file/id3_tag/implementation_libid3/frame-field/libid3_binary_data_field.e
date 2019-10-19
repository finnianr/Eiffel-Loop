note
	description: "Summary description for {LIBID3_BINARY_DATA_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_BINARY_DATA_FIELD

inherit
	ID3_BINARY_DATA_FIELD

	LIBID3_FRAME_FIELD

create
	make

feature -- Access

	binary_data: MANAGED_POINTER
			--
		do
			create Result.share_from_pointer (cpp_data (self_ptr), cpp_data_size (self_ptr))
		end

feature -- Element change

	set_binary_data (data: MANAGED_POINTER)
			--
		do
			bytes_read := cpp_set_data (self_ptr, data.item, data.count)
		end

feature {NONE} -- Internal attributes

	bytes_read: INTEGER

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_data >>
		end
end
