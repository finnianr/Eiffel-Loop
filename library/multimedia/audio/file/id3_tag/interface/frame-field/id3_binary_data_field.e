note
	description: "Summary description for {ID3_BINARY_DATA_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_BINARY_DATA_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	binary_data: MANAGED_POINTER
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.binary_data
		end

feature -- Element change

	set_binary_data (data: MANAGED_POINTER)
			--
		deferred
		ensure
			is_set: data.count > 0 implies data ~ binary_data -- Setting to length 0 does not work on libid3
		end

end
