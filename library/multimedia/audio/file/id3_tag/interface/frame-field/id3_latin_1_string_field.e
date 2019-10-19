note
	description: "Summary description for {ID3_STRING_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_LATIN_1_STRING_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	string: STRING_8
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.latin_1_string
		end

feature -- Element change

	set_string (str: like string)
			--
		deferred
		ensure
			is_set: string ~ str
		end
end
