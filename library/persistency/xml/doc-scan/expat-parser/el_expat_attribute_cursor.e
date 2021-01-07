note
	description: "[
		Cursor to iterate over C array of Expat Element attributes

			struct {
				char *name_s
				char *value_s
			}

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-07 12:52:29 GMT (Thursday 7th January 2021)"
	revision: "4"

class
	EL_EXPAT_ATTRIBUTE_CURSOR

inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		export
			{NONE} all
		end

	EL_POINTER_ROUTINES
		export
			{ANY} is_attached
		undefine
			is_equal, copy
		end

	EL_DOCUMENT_CLIENT
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			share_from_pointer (default_pointer, 0)
		end

feature -- Element change

	start (array_ptr: POINTER)
		-- initialize with attribute array C pointer
		require
			not_null: is_attached (array_ptr)
		do
			share_from_pointer (array_ptr, Size_of_attribute_struct)
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := not is_attached (read_pointer (0))
		end

feature -- Basic operations

	set_node (node: EL_ELEMENT_ATTRIBUTE_NODE_STRING)
		do
			node.raw_name.set_from_c (name_ptr)
			node.set_from_c (content_ptr)
		end

feature -- Status change

	forth
		do
			item := item + Size_of_attribute_struct
		end

feature {NONE} -- Implementation

	name_ptr: POINTER
		do
			Result := read_pointer (0)
		end

	content_ptr: POINTER
		do
			Result := read_pointer (Pointer_bytes)
		end

feature {NONE} -- Constants

	Size_of_attribute_struct: INTEGER
		-- struct {
		--		char *name_s
		--		char *value_s
		-- }
		once
			Result := Pointer_bytes * 2
		end
end