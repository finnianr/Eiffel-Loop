note
	description: "Summary description for {EL_CPP_ITERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_CPP_ITERATOR [G -> EL_CPP_OBJECT create make_from_pointer end]

inherit
	EL_CPP_OBJECT
		undefine
			cpp_delete
		redefine
			is_memory_owned
		end

	LINEAR [G]

feature {NONE} -- Initialization

	make (a_agent: like function_create_iterator)
			--
		do
			function_create_iterator := a_agent
		end

feature -- Access

	item: G

	index: INTEGER

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			dispose
			self_ptr := function_create_iterator.item ([])
			index := 0
			forth
		end

	forth
			-- Move to next position
		do
			cpp_item := cpp_iterator_next (self_ptr)
			index := index + 1
			if not after then
				item := create_item
--				create item.make_from_pointer (cpp_item)
				check
					item_does_not_own_memory: not item.is_memory_owned
					-- otherwise function is_empty will leak memory
				end
			end
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid position to the right of current one?
		do
			if index = 0 then
				Result := false
			else
				Result := not is_attached (cpp_item)
			end
		end

	is_empty: BOOLEAN
			-- Is there no element?
		local
			l_object_ptr: POINTER
		do
			l_object_ptr := function_create_iterator.item ([])
			if cpp_iterator_next (l_object_ptr) = Default_pointer then
				Result := True
			end
			cpp_delete (l_object_ptr)
		end

feature {NONE} -- Implementation

	create_item: G
		do
			create Result.make_from_pointer (cpp_item)
		end

	function_create_iterator: FUNCTION [ANY, TUPLE, POINTER]
		-- Current instance owns the resulting iterator and is responsible
		-- for deleting it

    cpp_item: POINTER

    is_memory_owned: BOOLEAN = true

feature {NONE} -- Unused

	finish
			-- Move to last position.
		do
		end

feature {NONE} -- Externals

    cpp_delete (self: POINTER)
            --
        deferred
        end

    cpp_iterator_next (iterator: POINTER): POINTER
            --
        deferred
        end

end
