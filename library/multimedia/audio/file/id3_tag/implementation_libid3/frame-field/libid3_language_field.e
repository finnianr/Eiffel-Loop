note
	description: "Summary description for {LIBID3_LANGUAGE_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_LANGUAGE_FIELD

inherit
	ID3_LANGUAGE_FIELD
		select
			string
		end

	LIBID3_LATIN_1_STRING_FIELD
		rename
			string as language
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
			Result := << FN_language >>
		end
end
