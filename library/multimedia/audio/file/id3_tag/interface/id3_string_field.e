note
	description: "Summary description for {ID3_STRING_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_STRING_FIELD

inherit
	ID3_ENCODEABLE_FRAME_FIELD

	ID3_SHARED_ENCODING_ENUM

feature -- Access

	string: ZSTRING
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.string
		end

feature -- Element change

	set_string (str: like string)
			--
		deferred
		ensure
			is_set: string ~ str
		end

end
