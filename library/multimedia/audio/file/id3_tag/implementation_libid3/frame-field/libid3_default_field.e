note
	description: "Summary description for {LIBID3_DEFAULT_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_DEFAULT_FIELD

inherit
	LIBID3_FRAME_FIELD
		redefine
			is_field_type_valid
		end

create
	make

feature -- Access

	type: NATURAL_8
		do
		end

feature -- Constant

	is_field_type_valid: BOOLEAN = True

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			create Result.make_empty
		end
end
