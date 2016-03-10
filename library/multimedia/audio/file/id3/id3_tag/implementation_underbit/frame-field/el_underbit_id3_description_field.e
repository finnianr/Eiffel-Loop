note
	description: "Summary description for {EL_UNDERBIT_ID3_DESCRIPTION_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_UNDERBIT_ID3_DESCRIPTION_FIELD

inherit
	EL_UNDERBIT_ID3_ENCODED_FIELD
		redefine
			type
		end

create
	make

feature -- Access

	type: INTEGER
		do
			Result := Type_description
		end
end
