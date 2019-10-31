note
	description: "Interface to a C++ iterator based on `std::list<T>::const_iterator'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 18:07:00 GMT (Wednesday   30th   October   2019)"
	revision: "1"

deferred class
	EL_CPP_STD_ITERATION_CURSOR [G -> EL_CPP_OBJECT]

inherit
	EL_OWNED_CPP_OBJECT
		redefine
			dispose
		end

	ITERATION_CURSOR [G]

feature {NONE} -- Initialization

	make (a_iterator_begin, a_iterator_end: POINTER)
			--
		do
			make_from_pointer (a_iterator_begin)
			iterator_end := a_iterator_end
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			cpp_next (self_ptr)
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid position?
		do
			Result := cpp_after (self_ptr, iterator_end)
		end

feature {NONE} -- Implementation

	dispose
			--
		do
			Precursor
			if is_attached (iterator_end) then
				cpp_delete (iterator_end)
				iterator_end := Default_pointer
			end
		end

feature {NONE} -- Externals

	cpp_after (iterator_begin, a_iterator_end: POINTER): BOOLEAN
		deferred
		end

	cpp_next (iterator: POINTER)
            --
		deferred
		end

	iterator_end: POINTER

end