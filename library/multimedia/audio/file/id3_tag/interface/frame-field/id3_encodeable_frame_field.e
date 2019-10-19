note
	description: "Summary description for {ID3_ENCODEABLE_FRAME_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID3_ENCODEABLE_FRAME_FIELD

inherit
	ID3_FRAME_FIELD

feature {NONE} -- Initialization

	make (self_ptr: POINTER; a_encoding: NATURAL_8)
		do
			make_from_pointer (self_ptr)
			encoding := a_encoding
		end

	make_from_pointer (self_ptr: POINTER)
		deferred
		end

feature -- Element change

	set_encoding (a_encoding: NATURAL_8)
			--
		deferred
		ensure
			set: encoding = a_encoding
		end

feature {NONE} -- Internal attributes

	encoding: NATURAL_8

end
