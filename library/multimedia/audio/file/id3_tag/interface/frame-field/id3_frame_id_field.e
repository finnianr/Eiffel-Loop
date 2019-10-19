note
	description: "Summary description for {ID3_FRAME_ID_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_FRAME_ID_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	id: STRING
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.frame_id
		end

feature -- Element change

	set_id (a_id: like id)
			--
		deferred
		ensure
			is_set: id = a_id
		end
end
