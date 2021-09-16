note
	description: "C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-15 20:07:16 GMT (Wednesday 15th September 2021)"
	revision: "8"

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

feature {EL_CPP_ITERATOR} -- Implementation

	self_ptr: POINTER

end