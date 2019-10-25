note
	description: "C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 12:55:24 GMT (Monday   7th   October   2019)"
	revision: "6"

deferred class
	EL_C_OBJECT

inherit
	EL_DISPOSEABLE
		export
			{NONE} all
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make_from_pointer (a_ptr: POINTER)
			--
		require
			valid_object: is_attached (a_ptr)
		do
			self_ptr := a_ptr
		end

feature {EL_CPP_ITERATOR} -- Implementation

	is_memory_owned: BOOLEAN
			--
		do
			Result := false
		end

	dispose
			--
		do
			if is_memory_owned and then is_attached (self_ptr) then
				c_free (self_ptr)
				self_ptr := Default_pointer
			end
		end

	c_free (this: POINTER)
			--
		do
		end

	self_ptr: POINTER

end
