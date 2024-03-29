note
	description: "C struct wrapper with managed memory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:15:26 GMT (Sunday 7th January 2024)"
	revision: "6"

deferred class
	EL_ALLOCATED_C_OBJECT

inherit
	EL_C_OBJECT
		rename
			make_from_pointer as make_c_object
		undefine
			copy, is_equal
		redefine
			self_ptr
		end

	MANAGED_POINTER
		rename
			make as make_with_size,
			item as self_ptr
		export
			{NONE} all
		redefine
			self_ptr
		end

feature {NONE} -- Initialization

	make_default
		do
			make_with_size (c_size_of)
		end

feature {EL_C_API} -- Implementation

	c_size_of: INTEGER
		-- size of C struct to allocate
		deferred
		end

feature {EL_C_API} -- Internal attributes

	self_ptr: POINTER
		-- allocated memory
end