note
	description: "Generic C++ iterator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 14:01:52 GMT (Wednesday   30th   October   2019)"
	revision: "9"

deferred class
	EL_CPP_ITERATOR [G -> EL_CPP_OBJECT]

inherit
	EL_OWNED_CPP_OBJECT

	TRAVERSABLE [G]

feature {NONE} -- Initialization

	make (a_agent: like function_create_iterator)
			--
		do
			function_create_iterator := a_agent
			item := default_item
		end

feature -- Access

	item: G

	linear_representation: ARRAYED_LIST [G]
		do
			create Result.make (0)
			from start until off loop
				Result.extend (item)
				forth
			end
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			cpp_item := cpp_iterator_next (self_ptr)
			set_item
		end

	start
			-- Move to first position if any.
		do
			dispose
			self_ptr := function_create_iterator.item ([])
			cpp_item := cpp_iterator_begin (self_ptr)
			set_item
		end

feature -- Status query

	off: BOOLEAN
			-- Is there no valid position?
		do
			Result := item = default_item
		end

feature -- Contract Support

	is_empty: BOOLEAN
			-- Is there no element?
		local
			l_self_ptr: POINTER
		do
			l_self_ptr := self_ptr -- Save current self
			self_ptr := function_create_iterator.item ([])
			cpp_item := cpp_iterator_begin (self_ptr)
			Result := cpp_off (self_ptr)
			dispose
			self_ptr := l_self_ptr
		end

feature {NONE} -- Implementation

	default_item: G
		deferred
		end

	has (v: G): BOOLEAN
		-- unused
		do
		end

	new_item: G
		-- new wrapper object `item' created from C++ reference `cpp_item'
		deferred
		end

	not_cpp_item_attached (self: POINTER): BOOLEAN
		do
			Result := not is_attached (cpp_item)
		end

	set_item
		do
			if cpp_off (self_ptr) then
				item := default_item
			else
				item := new_item
			end
		end

feature {NONE} -- Internal attributes

	function_create_iterator: FUNCTION [POINTER]
		-- Current instance owns the resulting iterator and is responsible
		-- for deleting it

    cpp_item: POINTER

feature {NONE} -- Externals

   cpp_off (self: POINTER): BOOLEAN
		deferred
		end

	cpp_delete (self: POINTER)
            --
		deferred
		end

	cpp_iterator_begin (iterator: POINTER): POINTER
            --
		deferred
		end

	cpp_iterator_next (iterator: POINTER): POINTER
            --
		deferred
		end

end
