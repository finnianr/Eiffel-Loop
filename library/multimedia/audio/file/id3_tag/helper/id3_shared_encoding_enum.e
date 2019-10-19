note
	description: "Summary description for {ID3_SHARED_ENCODING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_SHARED_ENCODING_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Encoding_enum: ID3_ENCODING_ENUM
		once
			create Result.make
		end

end
