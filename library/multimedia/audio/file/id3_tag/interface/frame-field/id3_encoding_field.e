note
	description: "Summary description for {ID3_ENCODING_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_ENCODING_FIELD

inherit
	ID3_FRAME_FIELD

	ID3_SHARED_ENCODING_ENUM

feature -- Access

	encoding: NATURAL_8
		deferred
		end

	name: STRING
		do
			Result := Encoding_enum.name (encoding)
		end

	type: NATURAL_8
		do
			Result := Field_type.encoding
		end

feature -- Element change

	set_encoding (a_encoding: NATURAL_8)
		deferred
		end
end
