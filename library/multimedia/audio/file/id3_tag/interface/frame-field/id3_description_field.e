note
	description: "Summary description for {ID3_DESCRIPTION_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_DESCRIPTION_FIELD

inherit
	ID3_STRING_FIELD
		redefine
			type
		end

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.description
		end
end
