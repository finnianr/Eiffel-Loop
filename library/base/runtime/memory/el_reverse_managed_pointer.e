note
	description: "[
		A [$source MANAGED_POINTER] that reads/writes numbers with opposite endianness to native
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-07 16:44:48 GMT (Monday 7th June 2021)"
	revision: "1"

class
	EL_REVERSE_MANAGED_POINTER

inherit
	MANAGED_POINTER
		redefine
			put_natural_16, put_natural_32, put_natural_64, put_real_32, put_real_64,
			read_natural_16, read_natural_32, read_natural_64, read_real_32, read_real_64
		end

	EL_BYTE_SWAP_ROUTINES_IMP
		undefine
			copy, is_equal
		end

create
	make, make_from_array, make_from_pointer, share_from_pointer, own_from_pointer

feature -- Read operations

	read_natural_16 (pos: INTEGER): NATURAL_16
			-- Read NATURAL_16 at position `pos'.
		do
			($Result).memory_copy (item + pos, natural_16_bytes)
			Result := reversed_16 (Result)
		end

	read_natural_32 (pos: INTEGER): NATURAL_32
			-- Read NATURAL_32 at position `pos'.
		do
			($Result).memory_copy (item + pos, natural_32_bytes)
			Result := reversed_32 (Result)
		end

	read_natural_64 (pos: INTEGER): NATURAL_64
		-- Read NATURAL_64 at position `pos'.
		do
			($Result).memory_copy (item + pos, natural_64_bytes)
			Result := reversed_64 (Result)
		end

	read_real_32 (pos: INTEGER): REAL_32
			-- Read REAL_32 at position `pos'.
		local
			n, reversed: NATURAL_32
		do
			($n).memory_copy (item + pos, Real_32_bytes)
			reversed := reversed_32 (n)
			($Result).memory_copy ($reversed, Real_32_bytes)
		end

	read_real_64 (pos: INTEGER): REAL_64
			-- Read REAL_64 at position `pos'.
		local
			n, reversed: NATURAL_64
		do
			($n).memory_copy (item + pos, Real_64_bytes)
			reversed := reversed_64 (n)
			($Result).memory_copy ($reversed, Real_64_bytes)
		end

feature -- Put operations

	put_natural_16 (v: NATURAL_16; pos: INTEGER)
		-- Insert byte reversed `v' at position `pos'.
		local
			reversed: NATURAL_16
		do
			reversed := reversed_16 (v)
			(item + pos).memory_copy ($reversed, natural_16_bytes)
		end

	put_natural_32 (v: NATURAL_32; pos: INTEGER)
		-- Insert byte reversed `v' at position `pos'.
		local
			reversed: NATURAL_32
		do
			reversed := reversed_32 (v)
			(item + pos).memory_copy ($reversed, natural_32_bytes)
		end

	put_natural_64 (v: NATURAL_64; pos: INTEGER)
		-- Insert byte reversed `v' at position `pos'.
		local
			reversed: NATURAL_64
		do
			reversed := reversed_64 (v)
			(item + pos).memory_copy ($reversed, natural_64_bytes)
		end

	put_real_32 (v: REAL_32; pos: INTEGER)
			-- Insert `v' at position `pos'.
		local
			n, reversed: NATURAL_32
		do
			($n).memory_copy ($v, Real_32_bytes)
			reversed := reversed_32 (n)
			(item + pos).memory_copy ($reversed, Real_32_bytes)
		end

	put_real_64 (v: REAL_64; pos: INTEGER)
			-- Insert `v' at position `pos'.
		local
			n, reversed: NATURAL_64
		do
			($n).memory_copy ($v, Real_64_bytes)
			reversed := reversed_64 (n)
			(item + pos).memory_copy ($reversed, Real_64_bytes)
		end

end