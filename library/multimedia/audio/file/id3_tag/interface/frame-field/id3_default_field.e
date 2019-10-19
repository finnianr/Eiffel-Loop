note
	description: "Summary description for {ID3_DEFAULT_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID3_DEFAULT_FIELD

inherit
	ANY
	
	ID3_FRAME_FIELD

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.default
		end
end
