note
	description: "C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 9:56:12 GMT (Saturday 26th October 2019)"
	revision: "7"

deferred class
	EL_C_OBJECT

inherit
	EL_POINTER_ROUTINES

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
