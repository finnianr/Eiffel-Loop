note
	description: "Owned c object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 10:06:15 GMT (Saturday   26th   October   2019)"
	revision: "1"

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
