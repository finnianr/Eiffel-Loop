note
	description: "[
		Style of C++ iterator that returns a pointer to a list object on each call of `cpp_next'
		until finally it returns the `NULL' pointer to indicate the the 'after' condition.
		
		`item' is a new wrapper object created from C++ reference `cpp_item'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 16:29:18 GMT (Wednesday 30th October 2019)"
	revision: "1"

deferred class
	EL_CPP_ITERATION_CURSOR [G -> EL_CPP_OBJECT]

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		redefine
			make
		end

	ITERATION_CURSOR [G]

feature {NONE} -- Initialization

	make (cpp_iterator: POINTER)
			--
		do
			Precursor (cpp_iterator)
			cpp_item := cpp_next (self_ptr)
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			cpp_item := cpp_next (self_ptr)
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid position?
		do
			Result := not is_attached (cpp_item)
		end

feature {NONE} -- Internal attributes

	cpp_item: POINTER

feature {NONE} -- Externals

	cpp_next (iterator: POINTER): POINTER
            --
		deferred
		end

end
