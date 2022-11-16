note
	description: "Id3 encodeable frame field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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