note
	description: "Bit routines that have a built-in compiler implementation [$source EL_BIT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-03 14:10:14 GMT (Sunday 3rd December 2023)"
	revision: "10"

deferred class
	EL_BIT_ROUTINES_I

inherit
	EL_OS_DEPENDENT

feature -- Measurement

	leading_zeros_count_32 (n: NATURAL_32): INTEGER
		-- number of trailing zeros before MSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	leading_zeros_count_64 (n: NATURAL_64): INTEGER
		-- number of trailing zeros before MSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	ones_count_32 (a_bitmap: NATURAL_32): INTEGER
		-- count of 1's in `bitmap'
		deferred
		end

	ones_count_64 (a_bitmap: NATURAL_64): INTEGER
		-- count of 1's in `bitmap'
		deferred
		end

	frozen precomputed_ones_count_32 (n: NATURAL_32): INTEGER
		-- count of 1's in 32-bit `n' without using gcc built-in
		local
			i: INTEGER; hi_bits, low_bits: NATURAL_32
		do
			if attached Precomputed_pop_count as pop_count then
				hi_bits := n |>> 16; low_bits := (n & 0xFFFF)
				from i := 0 until i > 8 loop
					Result := Result + pop_count [((hi_bits |>> i) & 0xFF).to_integer_32]
											 + pop_count [((low_bits |>> i) & 0xFF).to_integer_32]
					i := i + 8
				end
			end
		end

	frozen precomputed_ones_count_64 (n: NATURAL_64): INTEGER
		-- count of 1's in 64-bit `n' without using gcc built-in
		local
			i: INTEGER; hi_bits, low_bits: NATURAL_64
		do
			if attached Precomputed_pop_count as pop_count then
				hi_bits := n |>> 32; low_bits := (n & 0xFFFF_FFFF)
				from i := 0 until i > 24 loop
					Result := Result + pop_count [((hi_bits |>> i) & 0xFF).to_integer_32]
											+ pop_count [((low_bits |>> i) & 0xFF).to_integer_32]
					i := i + 8
				end
			end
		end

	trailing_zeros_count_32 (n: NATURAL_32): INTEGER
		-- number of trailing zeros after LSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	trailing_zeros_count_64 (n: NATURAL_64): INTEGER
		-- number of trailing zeros after LSB
		-- `n = 0' is undefined on gcc
		require
			not_zero: n /= 0
		deferred
		end

	zero_or_one (n: NATURAL_32): NATURAL_32
		-- 1 if `n > 0' or else 0
		deferred
		ensure
			valid_n_gt_zero: n > 0 implies Result = 1
			valid_n_zero: n = 0 implies Result = 0
		end

feature {NONE} -- Constants

	Precomputed_pop_count: SPECIAL [NATURAL_8]
		local
			one_bit, i, count: INTEGER
		once
			create Result.make_empty (0xFF + 1)
			from until i > 0xFF loop
				count := 0
				from one_bit := 1 until one_bit > 0x80 loop
					count := count + (i & one_bit).to_boolean.to_integer
					one_bit := one_bit |<< 1
				end
				Result.extend (count.to_natural_8)
				i := i + 1
			end
		end

end