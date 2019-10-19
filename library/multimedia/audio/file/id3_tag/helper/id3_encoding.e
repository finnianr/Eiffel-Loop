note
	description: "Summary description for {ID3_ENCODING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID3_ENCODING

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Encoding_enum
		redefine
			make_default
		end

	ID3_SHARED_ENCODING_ENUM

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			value := Encoding_enum.unknown
		end
end
