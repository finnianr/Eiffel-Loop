note
	description: "Id3 encodeable frame field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-11 13:58:04 GMT (Friday 11th October 2019)"
	revision: "1"

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
