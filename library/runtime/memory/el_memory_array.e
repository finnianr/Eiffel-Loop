note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_MEMORY_ARRAY [G]

inherit
	MANAGED_POINTER
		rename
			item as to_c,
			make as ptr_make,
			count as byte_count,
			resize as resize_memory
		export
			{NONE} all
			{ANY} to_c
		end

feature -- Initialization

	make (a_ptr: POINTER; max_index: INTEGER)
			--
		do
			count := max_index
			share_from_pointer (a_ptr, count * item_bytes)
		end

feature -- Element change

	put (v: like item; i: INTEGER)
			--
		require
			valid_i: i >= 1 and i <= count
		do
			put_memory (v, (i - 1) * item_bytes)
		end

	copy_from_array (other: ARRAY [G])
			--
		require
			is_same_size_as_other: other.count = count
		local
			l_area: ANY
		do
			l_area := other.to_c
			to_c.memory_copy ($l_area, count * item_bytes)
		end

feature -- Resizing

	resize (new_count: INTEGER)
			--
		require
			valid_new_count: new_count <= count
		do
			count := new_count
		end

feature -- 	Access

	i_th (i: INTEGER): like item
			--
		require
			valid_i: i >= 1 and i <= count
		do
			Result := read_memory ((i - 1) * item_bytes)
		end

	count: INTEGER

	item_bytes: INTEGER
			--
		deferred
		end

feature {NONE} -- Implementation

	item: G

	put_memory (v: like item; pos: INTEGER)
			--
		deferred
		end

	read_memory (pos: INTEGER): like item
			--
		deferred
		end

end
