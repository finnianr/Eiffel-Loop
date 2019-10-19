note
	description: "Summary description for {LIBID3_FRAME_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	LIBID3_FRAME_FIELD

inherit
	ID3_FRAME_FIELD

	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		redefine
			make
		end

	LIBID3_ID3_FIELD_CPP_API

	LIBID3_CONSTANTS

	ID3_SHARED_FRAME_FIELD_TYPES

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
			--
		do
			Precursor (a_ptr)
		ensure then
			valid_field_type: is_field_type_valid
		end

feature -- Access

	libid3_field_type: INTEGER
		do
			Result := cpp_id (self_ptr)
		end

feature {NONE} -- Implementation

	is_field_type_valid: BOOLEAN
		do
			Result := Libid3_types.has (libid3_field_type)
		end

	libid3_types: ARRAY [INTEGER]
		deferred
		end

feature {NONE} -- Internal attributes

	c_call_succeeded: BOOLEAN

end
