note
	description: "C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:15:52 GMT (Sunday 7th January 2024)"
	revision: "13"

deferred class
	EL_C_OBJECT

inherit
	EL_MEMORY_ROUTINES

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

feature {EL_C_API} -- Internal attributes

	self_ptr: POINTER

end