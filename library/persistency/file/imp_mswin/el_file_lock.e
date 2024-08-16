note
	description: "Windows file lock information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-16 9:21:37 GMT (Friday 16th August 2024)"
	revision: "7"

class
	EL_FILE_LOCK

inherit
	EL_FILE_LOCK_I [POINTER]
		rename
			c_size_of as c_overlap_struct_size
		end

	EL_FILE_LOCK_C_API
		undefine
			copy, is_equal
		end

create
	make, make_write

feature {NONE} -- Initialization

	make (a_length: NATURAL_64)
		do
			make_default
			length :=  a_length
		end

	make_write (a_file_handle: POINTER)
		local
			n: NATURAL_64
		do
			file_handle := a_file_handle
			make (n.Max_value) -- `Max_value' means any length of file
		end

feature -- Status query

	is_lockable: BOOLEAN
		do
			Result := is_attached (file_handle)
		end

feature -- Status change

	try_lock
		do
			is_locked := c_lock_file (file_handle, self_ptr, length_1_to_32, length_33_to_64)
		end

	unlock
		do
			is_locked := not c_unlock_file (file_handle, self_ptr, length_1_to_32, length_33_to_64)
		end

feature {NONE} -- Implementation

	length_33_to_64: NATURAL_32
		-- high bytes
		do
			Result := (length |>> {PLATFORM}.Natural_32_bits).to_natural_32
		end

	length_1_to_32: NATURAL_32
		-- low bytes
		do
			Result := length.to_natural_32
		end

feature {NONE} -- Internal attributes

	length: NATURAL_64

end