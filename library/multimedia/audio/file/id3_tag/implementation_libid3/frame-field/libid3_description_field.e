note
	description: "Summary description for {LIBID3_DESCRIPTION_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_DESCRIPTION_FIELD

inherit
	ID3_DESCRIPTION_FIELD

	LIBID3_STRING_FIELD
		undefine
			type
		redefine
			Libid3_types
		end

create
	make

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_description >>
		end
end
