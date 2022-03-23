note
	description: "C struct wrapper with managed memory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-27 13:44:19 GMT (Monday 27th July 2020)"
	revision: "3"

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

feature {NONE} -- Implementation

	c_size_of: INTEGER
		-- size of C struct to allocate
		deferred
		end

feature {NONE} -- Internal attributes

	self_ptr: POINTER
		-- allocated memory
end
