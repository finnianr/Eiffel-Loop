note
	description: "C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 16:52:42 GMT (Tuesday 31st May 2022)"
	revision: "9"

deferred class
	EL_C_OBJECT

inherit
	EL_C_API_ROUTINES

feature {NONE} -- Initialization

	make_from_pointer (a_ptr: POINTER)
			--
		require
			valid_object: is_attached (a_ptr)
		do
			self_ptr := a_ptr
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := is_attached (self_ptr)
		end

feature {EL_CPP_ITERATOR} -- Implementation

	self_ptr: POINTER

end