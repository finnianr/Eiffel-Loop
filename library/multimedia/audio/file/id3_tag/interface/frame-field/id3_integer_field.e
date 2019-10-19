note
	description: "Summary description for {ID3_INTEGER_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_INTEGER_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	integer: INTEGER
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.integer
		end

feature -- Element change

	set_integer (a_integer: like integer)
			--
		deferred
		ensure
			is_set: integer = a_integer
		end
end
