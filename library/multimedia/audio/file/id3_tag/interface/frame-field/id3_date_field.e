note
	description: "Summary description for {ID3_DATE_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_DATE_FIELD

inherit
	ID3_LATIN_1_STRING_FIELD
		redefine
			type
		end

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.date
		end
end
