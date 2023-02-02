note
	description: "Test descendants of [$source EL_NUMERIC_BIT_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-02 11:09:01 GMT (Thursday 2nd February 2023)"
	revision: "2"

class
	BIT_ROUTINE_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("de_brujin_generation", agent test_de_brujin_generation)
			eval.call ("integer_32_bit_routines", agent test_integer_32_bit_routines)
			eval.call ("integer_64_bit_routines", agent test_integer_64_bit_routines)
			eval.call ("natural_32_bit_routines", agent test_natural_32_bit_routines)
			eval.call ("natural_64_bit_routines", agent test_natural_64_bit_routines)
		end

feature -- Tests

	test_de_brujin_generation
		local
			answer: ARRAY [NATURAL_8]
			i: INTEGER; n, mask_5_bit: NATURAL_32
		do
			answer := <<
				0, 1, 2, 24, 3,19, 6,25, 22, 4, 20, 10, 16, 7, 12, 26, 31, 23, 18,
				5, 21, 9, 15, 11, 30,17, 8, 14, 29, 13, 28, 27
			>>
			mask_5_bit := 0x1F
			from until i = 32 loop
				lio.put_natural_field (i.out, ((n.one |<< i) * De_Bruijn_number) |>> 27)
				lio.put_new_line
				n := (((n.one |<< i) * De_Bruijn_number) |>> 27) & mask_5_bit
				assert ("same value", n.to_natural_8 = answer [i + 1])
				i := i + 1
			end
		end

	test_integer_32_bit_routines
		-- GENERAL_TEST_SET.test_integer_32_bit_routines
		local
			i32: EL_INTEGER_32_BIT_ROUTINES
			i, value, initial_value, mask: INTEGER
		do
--			count trailing zeros
			assert ("one has 0", i32.shift_count (1) = 0)
			assert ("zero has 32", i32.shift_count (0) = 32)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("zero count OK", i32.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("filled_bits OK", i32.filled_bits (4) = 0xF)

			assert ("0xF fits in 0xF0", i32.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not i32.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", i32.valid_mask (0xF0))
			assert ("0x3 has continous bits", i32.valid_mask (0x3))
			assert ("1001 bits are not continuous", not i32.valid_mask (0x90))

			assert ("set 8 shifted right by 4", i32.inserted (0x000, 0x0F0, 8) = 0x080)
			assert ("set 8 shifted right by 8", i32.inserted (0x080, 0xF00, 8) = 0x880)
			assert ("set 8 shifted right by 24", i32.inserted (0x000, 0xF0_0000, 8) = 0x80_0000)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("insert OK", i32.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("value in position 3 is 0x8", i32.isolated (0x881, 0xF00) = 0x08)
			assert ("value in position 2 is 0x8", i32.isolated (0x881, 0x0F0) = 0x08)
			assert ("value in position 1 is 0x1", i32.isolated (0x881, 0x00F) = 0x1)
		end

	test_integer_64_bit_routines
		-- GENERAL_TEST_SET.test_integer_64_bit_routines
		local
			i64: EL_INTEGER_64_BIT_ROUTINES; i: INTEGER
			value, initial_value, mask, combined_value, expected_value: INTEGER_64
			array: ARRAY [INTEGER_64]
		do
--			count trailing zeros
			assert ("one has 0", i64.shift_count (1) = 0)
			assert ("zero has 64", i64.shift_count (0) = 64)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 63 loop
				assert ("zero count OK", i64.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("filled_bits OK", i64.filled_bits (4) = 0xF)
			assert ("filled_bits OK", i64.filled_bits (64) = 0xFFFFFFFF_FFFFFFFF)

			assert ("0xF fits in 0xF0", i64.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not i64.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", i64.valid_mask (0xF0))
			assert ("0x3 has continous bits", i64.valid_mask (0x3))
			assert ("1001 bits are not continuous", not i64.valid_mask (0x90))

			array := <<
				0x000, 0x0F0, 0x080,
				0x080, 0xF00, 0x880,
				0x000, 0xF0_0000, 0x80_0000
			>>
			from i := 0 until i = 3 loop
				across << 0, 16 >> as shift_n loop
					combined_value := array.area [i * 3 + 0] |<< shift_n.item
					mask := array.area [i * 3 + 1] |<< shift_n.item
					expected_value := array.area [i * 3 + 2] |<< shift_n.item
					assert ("valid combined value", i64.inserted (combined_value, mask, 8) = expected_value)
				end
				i := i + 1
			end

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 60 loop
				assert ("insert OK", i64.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			array := <<
				0x881, 0xF00, 0x08,
				0x881, 0x0F0, 0x08,
				0x881, 0x00F, 0x1
			>>
			from i := 0 until i = 3 loop
				across << 0, 16 >> as shift_n loop
					combined_value := array.area [i * 3 + 0] |<< shift_n.item
					mask := array.area [i * 3 + 1] |<< shift_n.item
					expected_value := array.area [i * 3 + 2]
					assert ("valid value", i64.isolated (combined_value, mask) = expected_value)
				end
				i := i + 1
			end
		end

	test_natural_32_bit_routines
		-- GENERAL_TEST_SET.test_natural_32_bit_routines
		local
			n32: EL_NATURAL_32_BIT_ROUTINES
			i: INTEGER; value, initial_value, mask: NATURAL_32
		do
--			count trailing zeros
			assert ("one has 0", n32.shift_count (1) = 0)
			assert ("zero has 32", n32.shift_count (0) = 32)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("zero count OK", n32.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("filled_bits OK", n32.filled_bits (4) = 0xF)

			assert ("0xF fits in 0xF0", n32.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not n32.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", n32.valid_mask (0xF0))
			assert ("0x3 has continous bits", n32.valid_mask (0x3))
			assert ("1001 bits are not continuous", not n32.valid_mask (0x90))

			assert ("set 8 shifted right by 4", n32.inserted (0x000, 0x0F0, 8) = 0x080)
			assert ("set 8 shifted right by 8", n32.inserted (0x080, 0xF00, 8) = 0x880)
			assert ("set 8 shifted right by 24", n32.inserted (0x000, 0xF0_0000, 8) = 0x80_0000)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 28 loop
				assert ("insert OK", n32.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("value in position 3 is 0x8", n32.isolated (0x881, 0xF00) = 0x08)
			assert ("value in position 2 is 0x8", n32.isolated (0x881, 0x0F0) = 0x08)
			assert ("value in position 1 is 0x1", n32.isolated (0x881, 0x00F) = 0x1)
		end

	test_natural_64_bit_routines
		-- GENERAL_TEST_SET.test_natural_64_bit_routines
		local
			n64: EL_NATURAL_64_BIT_ROUTINES
			i: INTEGER; value, initial_value, mask, combined_value, expected_value: NATURAL_64
			array: ARRAY [NATURAL_64]
		do
--			count trailing zeros
			assert ("one has 0", n64.shift_count (1) = 0)
			assert ("zero has 64", n64.shift_count (0) = 64)

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 63 loop
				assert ("zero count OK", n64.shift_count (mask) = i)
				mask := mask |<< 1
				i := i + 1
			end

			assert ("filled_bits OK", n64.filled_bits (4) = 0xF)
			assert ("filled_bits OK", n64.filled_bits (64) = 0xFFFFFFFF_FFFFFFFF)

			assert ("0xF fits in 0xF0", n64.compatible_value (0xF0, 0xF))
			assert ("0x10 does not fit in 0xF0", not n64.compatible_value (0xF0, 0x10))

			assert ("0xF0 has continous bits", n64.valid_mask (0xF0))
			assert ("0x3 has continous bits", n64.valid_mask (0x3))
			assert ("1001 bits are not continuous", not n64.valid_mask (0x90))

			array := <<
				0x000, 0x0F0, 0x080,
				0x080, 0xF00, 0x880,
				0x000, 0xF0_0000, 0x80_0000
			>>
			from i := 0 until i = 3 loop
				across << 0, 16 >> as shift_n loop
					combined_value := array.area [i * 3 + 0] |<< shift_n.item
					mask := array.area [i * 3 + 1] |<< shift_n.item
					expected_value := array.area [i * 3 + 2] |<< shift_n.item
					assert ("valid combined value", n64.inserted (combined_value, mask, 8) = expected_value)
				end
				i := i + 1
			end

			initial_value := 1; mask := 0x7 -- 0111
			from i := 0  until i > 61 loop
				assert ("insert OK", n64.inserted (0, mask, 1) = initial_value |<< i)
				mask := mask |<< 1
				i := i + 1
			end

			array := <<
				0x881, 0xF00, 0x08,
				0x881, 0x0F0, 0x08,
				0x881, 0x00F, 0x1
			>>
			from i := 0 until i = 3 loop
				across << 0, 16 >> as shift_n loop
					combined_value := array.area [i * 3 + 0] |<< shift_n.item
					mask := array.area [i * 3 + 1] |<< shift_n.item
					expected_value := array.area [i * 3 + 2]
					assert ("valid value", n64.isolated (combined_value, mask) = expected_value)
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	De_Bruijn_number: NATURAL = 0x4D7651F

	De_Bruijn_sequence: SPECIAL [NATURAL_8]
		local
			i: INTEGER; n: NATURAL_32
		once
			create Result.make_empty (32)
			from until i = 32 loop
				n := (((n.one |<< i) * De_Bruijn_number) |>> 27) & 0x1F
				Result.extend (n.to_natural_8)
				i := i + 1
			end
		end

end