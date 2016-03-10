note
	description: "[
		bytes with a count equal to muliple of a_block_size.
		Creation area arguments that do not fit exactly are padded with bytes of value equal to the padding count.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PADDED_BYTE_ARRAY

inherit
	EL_BYTE_ARRAY
		rename
			make as make_array,
			make_from_string as make_array_from_string,
			make_from_managed as make_array_from_managed,
			make_from_area as make_array_from_area
		end

create
	make_from_area, make_from_string, make_from_managed, make

feature {NONE} -- Initialization

	make_from_area (other: like area; a_block_size: INTEGER)
			--
		do
			if other.count \\ a_block_size = 0 then
				area := other
			else
				make (other.count, a_block_size)
				area.base_address.memory_copy (other.base_address, other.count)
			end
		end

	make (size, a_block_size: INTEGER)
		local
			padding, remainder, i: INTEGER
		do
			remainder := size \\ a_block_size
			if remainder > 0 then
				padding := a_block_size - remainder
				make_array (size + padding)
				from i := 0 until i = padding loop
					area.put (padding.to_natural_8, size + i)
					i := i + 1
				end
			else
				make_array (size)
			end
			block_size := a_block_size
		end

	make_from_string (str: STRING; a_block_size: INTEGER)
		do
			make (str.count, a_block_size)
			area.base_address.memory_copy (str.area.base_address, str.count)
		end

	make_from_managed (managed: MANAGED_POINTER; n, a_block_size: INTEGER)
		do
			make (n, a_block_size)
			area.base_address.memory_copy (managed.item, n)
		end

feature -- Access

	padding_count: INTEGER
			-- count of extra bytes needed to make data fit multiple of block size argument
		local
			padding_candidate: NATURAL_8
			i, last_index: INTEGER
			is_padded: BOOLEAN
		do
			last_index := count - 1
			padding_candidate := area.item (last_index)
			if padding_candidate >= 1 and padding_candidate < block_size then
				is_padded := True
				from i := count - padding_candidate until not is_padded or i > last_index loop
					is_padded := area.item (i) = padding_candidate
					i := i + 1
				end
				if is_padded then
					Result := padding_candidate
				end
			end
		end

	block_size: INTEGER

feature -- Conversion

	to_unpadded_string: STRING
		do
			create Result.make_filled (create {CHARACTER}, count)
			Result.area.base_address.memory_copy (area.base_address, count)
			Result.remove_tail (padding_count)
		end

	to_unpadded_array: ARRAY [NATURAL_8]
		do
			create Result.make_from_special (area)
			Result.remove_tail (padding_count)
		end

	unpadded: like area
		do
			Result := area.twin
			Result.remove_tail (padding_count)
		end

end
