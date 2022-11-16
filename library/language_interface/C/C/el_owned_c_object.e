note
	description: "Owned C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_OWNED_C_OBJECT

inherit
	EL_C_OBJECT

	EL_DISPOSEABLE
		export
			{NONE} all
		redefine
			dispose
		end

feature {EL_CPP_ITERATOR} -- Implementation

	dispose
			--
		do
			if is_attached (self_ptr) then
				c_free (self_ptr)
				self_ptr := Default_pointer
			end
		end

	c_free (this: POINTER)
			--
		deferred
		end

end