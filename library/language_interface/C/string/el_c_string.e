note
	description: "C string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-01 16:23:07 GMT (Tuesday 1st August 2023)"
	revision: "15"

deferred class
	EL_C_STRING

inherit
	MANAGED_POINTER
		rename
			item as base_address,
			count as byte_count,
			make as make_buffer,
			append as append_buffer
		export
			{NONE} all
			{ANY} base_address
		redefine
			default_create
		end

	EL_C_API_ROUTINES
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	EL_BIT_COUNTABLE

	EL_SHARED_IMMUTABLE_32_MANAGER

feature {NONE} -- Initialization

	make_owned (c_ptr: POINTER)
			--
		do
			make_with_ownership (c_ptr, True)
		end

	make_owned_of_size (c_ptr: POINTER; size: INTEGER)
			--
		do
			make_with_size_and_ownership (c_ptr, size, True)
		end

	make_shared (c_ptr: POINTER)
			-- make shared
		do
			make_with_ownership (c_ptr, False)
		end

	make_shared_of_size (c_ptr: POINTER; size: INTEGER)
			-- make shared
		do
			make_with_size_and_ownership (c_ptr, size, False)
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			make (0)
		end

	make (a_count: INTEGER)
			--
		do
			count := a_count
			capacity := a_count
			if count > 0 then
				make_buffer ((count + 1) * width)
				put_item (0, count + 1)
			else
				base_address := Default_pointer
				is_shared := true
			end
		end

	make_from_string (string: READABLE_STRING_GENERAL)
			--
		local
			i: INTEGER
		do
			count := string.count
			capacity := count + 1
			make_buffer (capacity * width)
			from i := 1 until i > count loop
				put_item (string.code (i), i)
				i := i + 1
			end
			put_item (0, i)
		end

	make_with_ownership (c_ptr: POINTER; owned: BOOLEAN)
			--
		local
			p: EL_POINTER_ROUTINES
		do
			if is_attached (c_ptr) then
				make_with_size_and_ownership (c_ptr, p.string_length (c_ptr, width), owned)
			else
				make_with_size_and_ownership (c_ptr, 0, owned)
			end
		end

	make_with_size_and_ownership (c_ptr: POINTER; size: INTEGER; owned: BOOLEAN)
			--
		do
			if is_attached (base_address) then
				dispose
			end
			count := size; capacity := size + 1
			if owned then
				own_from_pointer (c_ptr, capacity * width)
			else
				share_from_pointer (c_ptr, capacity * width)
			end
		ensure
			correct_sized_buffer: byte_count // width = capacity
		end

feature -- Measurement

	capacity: INTEGER

	count: INTEGER

feature -- Access

	code (index: INTEGER): NATURAL_32
			--
		require
			valid_index: index >= 1 and index <= count
		deferred
		end

	item (index: INTEGER): CHARACTER_32
			--
		require
			valid_index: index >= 1 and index <= count
		do
			Result := code (index).to_character_32
		end

feature -- Conversion

	to_boolean: BOOLEAN
		do
			if count = 4 then
				Result := code (1).to_character_32.as_upper = 'T'
			end
		end

feature -- Element change	

	append (string: READABLE_STRING_GENERAL)
			--
		local
			new_string: STRING_32
		do
			if not is_attached (base_address) and is_shared then
				is_shared := false -- to satisfy precondition in MANAGED_POINTER make
				make_from_string (string)

			else
				new_string := as_string_32
				new_string.append_string_general (string)
				dispose
				make_from_string (new_string)
			end
		end

	put_item (value: NATURAL_32; index: INTEGER)
			--
		require
			valid_index: index >= 1 and index <= count + 1
			value_small_enough: is_value_small_enough (value)
		deferred
		end

	set_count (new_count: INTEGER)
			--
		require
			valid_new_count: new_count >= 0 and new_count <= capacity
		do
			count := new_count
		end

	set_owned_from_c (c_ptr: POINTER)
			--
		do
			make_with_ownership (c_ptr, True)
		end

	set_owned_from_c_of_size (c_ptr: POINTER; size: INTEGER)
			--
		do
			make_with_size_and_ownership (c_ptr, size, True)
		end

	set_shared_from_c (c_ptr: POINTER)
			-- make shared
		do
			make_with_ownership (c_ptr, False)
		end

	set_shared_from_c_of_size (c_ptr: POINTER; size: INTEGER)
			-- make shared
		do
			make_with_size_and_ownership (c_ptr, size, False)
		end

feature -- Set external strings

	fill_string (string: STRING_GENERAL)
			-- Fill string argument with all characters
		local
			i, l_count: INTEGER
		do
			l_count := count
			from i := 1 until i > l_count loop
				string.append_code (code (i))
				i := i + 1
			end
		end

feature -- Removal

	wipe_out
			--
		do
			dispose
			count := 0
			byte_count := 0
			is_shared := true
		end

feature -- Status query

	is_empty: BOOLEAN
			--
		do
			Result := count = 0 or else count = 1 and code (1) = 0
		end

	is_owned: BOOLEAN
			--
		do
			Result := not is_shared
		end

	is_value_small_enough (value: NATURAL_32): BOOLEAN
		--
		do
			Result := width < Natural_32_bytes implies value.bit_shift_right (width * 8) = 0
		end

feature -- Conversion

	as_array: SPECIAL [CHARACTER_32]
		-- character array with terminating NULL character
		local
			i, l_count: INTEGER
		do
			l_count := count
			create Result.make_empty (l_count + 1)
			from i := 1 until i > l_count loop
				Result.extend (code (i).to_character_32)
				i := i + 1
			end
			Result.extend ('%U')
		end

	as_immutable_32: IMMUTABLE_STRING_32
			--
		do
			Result := shared_immutable_32.twin
		end

	as_string: ZSTRING
			--
		do
			create Result.make_from_general (shared_immutable_32)
		end

	as_string_32: STRING_32
			--
		do
			create Result.make_from_string (shared_immutable_32)
		end

	as_string_8: STRING
			--
		do
			Result := shared_immutable_32.to_string_8
		end

feature {NONE} -- Implementation

	shared_immutable_32: IMMUTABLE_STRING_32
			--
		do
			Immutable_32.set_item (as_array, 0, count)
			Result := Immutable_32.item
		end

feature {NONE} -- Deferred

	width: INTEGER
			-- character width in bytes
		deferred
		end


end
