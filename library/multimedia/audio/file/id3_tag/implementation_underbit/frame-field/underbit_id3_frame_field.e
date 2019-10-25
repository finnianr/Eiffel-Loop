note
	description: "Underbit id3 frame field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-11 9:27:29 GMT (Friday   11th   October   2019)"
	revision: "1"

deferred class
	UNDERBIT_ID3_FRAME_FIELD

inherit
	ID3_FRAME_FIELD

	EL_C_OBJECT
		rename
			make_from_pointer as make
		redefine
			make
		end

	UNDERBIT_ID3_CONSTANTS

	UNDERBIT_ID3_C_API
		undefine
			dispose
		end

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
			--
		do
			Precursor (a_ptr)
		ensure then
			valid_field_type: is_field_type_valid
		end

feature -- Access

	underbit_field_type: INTEGER
		do
			Result := c_id3_field_type (self_ptr)
		end

feature {NONE} -- Implementation

	underbit_type: INTEGER
		deferred
		end

	set_immediate_value (str: STRING)
		require
			valid_size: str.count <= 8
		local
			to_c: ANY
		do
			if str.count <= 8 then
				to_c := str.to_c
				c_id3_field_value (self_ptr).memory_copy ($to_c, str.count + 1)
			end
		end

	is_field_type_valid: BOOLEAN
		do
			Result := underbit_field_type = underbit_type
		end

feature {NONE} -- Internal attributes

	c_call_status: INTEGER

end

