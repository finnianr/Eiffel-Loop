note
	description: "Summary description for {EL_CPP_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_CPP_OBJECT

inherit
	EL_MEMORY
		export
			{NONE} all
		redefine
			dispose
		end

feature {NONE} -- Initialization

	make_from_pointer (cpp_ptr: POINTER)
			--
		require
			valid_object: is_attached (cpp_ptr)
		do
			self_ptr := cpp_ptr
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
				cpp_delete (self_ptr)
				self_ptr := Default_pointer
			end
		end

	cpp_delete (this: POINTER)
			--
		do
		end

	self_ptr: POINTER

end
