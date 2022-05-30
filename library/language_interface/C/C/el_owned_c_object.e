note
	description: "Owned C object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-29 13:12:37 GMT (Sunday 29th May 2022)"
	revision: "2"

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