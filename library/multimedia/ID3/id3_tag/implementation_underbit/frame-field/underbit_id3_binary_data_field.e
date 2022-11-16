note
	description: "Underbit id3 binary data field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	UNDERBIT_ID3_BINARY_DATA_FIELD

inherit
	ID3_BINARY_DATA_FIELD

	UNDERBIT_ID3_FRAME_FIELD
		redefine
			is_field_type_valid
		end

create
	make

feature -- Access

	binary_data: MANAGED_POINTER
			--
		local
			data_count: NATURAL; data_ptr: POINTER
		do
			data_ptr := c_id3_field_getbinarydata (self_ptr, $data_count)
			if data_ptr = default_pointer then
				create Result.make (0)
			else
				create Result.share_from_pointer (data_ptr, data_count.to_integer_32)
			end
		end

feature -- Element change

	set_binary_data (data: MANAGED_POINTER)
			--
		do
			c_call_status := c_id3_field_setbinarydata (self_ptr, data.item, data.count)
		ensure then
			is_set: c_call_status = 0
		end

feature {NONE} -- Contract Support

	is_field_type_valid: BOOLEAN
		do
			Result := Precursor or else underbit_field_type = Field_type_int32_plus
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_binary_data
		end

end