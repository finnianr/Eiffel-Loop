note
	description: "Compare methods to caculate population of 1's in [$source NATURAL_64]"
	notes: "[
		Passes over 2000 millisecs (in descending order)

			gcc built-in                   : 30581.0 times (100%)
			Precomputed pop count for byte : 16925.0 times (-44.7%)
			Precomputed pop count ver 3    : 16816.0 times (-45.0%)
			Precomputed pop count ver 2    : 16802.0 times (-45.1%)
			Alternating leading / trailing :  6011.0 times (-80.3%)
			Nested 64, 32, 16, 8, inspect  :  2667.0 times (-91.3%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-02 14:52:44 GMT (Saturday 2nd December 2023)"
	revision: "7"

class
	BIT_POP_COUNT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_BIT_ROUTINES
		rename
			ones_count_64 as gcc_ones_count_64,
			ones_count_32 as gcc_ones_count_32
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "Compare bit population count methods"

feature -- Basic operations

	execute
		do
			compare (Description, <<
				["gcc built-in",						  agent do_pop_count (1)],
				["Alternating leading / trailing", agent do_pop_count (2)],
				["Nested 64, 32, 16, 8, inspect",  agent do_pop_count (3)],
				["Precomputed pop count for byte", agent do_pop_count (4)],
				["Precomputed pop count ver 2",	  agent do_pop_count (5)],
				["Precomputed pop count ver 3",	  agent do_pop_count (6)]
			>>)
		end

feature {NONE} -- Implementation

	do_pop_count (method_id: INTEGER)
		local
			i, count: INTEGER; n: NATURAL_64
		do
			if attached crc_generator as crc then
				from i := 0 until i > 2000 loop
					crc.add_integer (i)
					n := crc.checksum
					n := (n |<< 32) | n
					inspect method_id
						when 1 then
							count := gcc_ones_count_64 (n)
						when 2 then
							count := slow_ones_count_64 (n)
						when 3 then
							count := nested_ones_count_64 (n)
						when 4 then
							count := precomputed_ones_count_64 (n)
						when 5 then
							count := precomputed_ones_count_64_v2 (n)
						when 6 then
							count := precomputed_ones_count_64_v3 (n)
					end
					i := i + 1
				end
			end
		end

	frozen nested_ones_count_64 (n: NATURAL_64): INTEGER
		do
			Result := ones_count_32 (n.to_natural_32) + ones_count_32 ((n |>> 32).to_natural_32)
		ensure
			same_as_built_in: Result = gcc_ones_count_64 (n)
		end

	frozen ones_count_16 (n: NATURAL_16): INTEGER
		do
			Result := ones_count_8 (n.to_natural_8) + ones_count_8 ((n |>> 8).to_natural_8)
		end

	frozen ones_count_32 (n: NATURAL_32): INTEGER
		do
			Result := ones_count_16 (n.to_natural_16) + ones_count_16 ((n |>> 16).to_natural_16)
		end

	frozen ones_count_8 (byte: NATURAL_8): INTEGER
		local
			lower, upper: INTEGER
		do
			inspect byte & 0xF
				when 0b0000 then
					lower := 0
				when 0b0001, 0b0010, 0b0100, 0b1000 then
					lower := 1
				when 0b0011, 0b0101, 0b0110, 0b1001, 0b1010, 0b1100 then
					lower := 2
				when 0b0111, 0b1011, 0b1101, 0b1110 then
					lower := 3
				when 0b1111 then
					lower := 4
			end
			inspect byte & 0xF0
				when 0b00000000 then
					upper := 0
				when 0b00010000, 0b00100000, 0b01000000, 0b10000000 then
					upper := 1
				when 0b00110000, 0b01010000, 0b01100000, 0b10010000, 0b10100000, 0b11000000 then
					upper := 2
				when 0b01110000, 0b10110000, 0b11010000, 0b11100000 then
					upper := 3
				when 0b11110000 then
					upper := 4
			end
			Result := lower + upper
		end

	frozen precomputed_ones_count_64_v2 (n: NATURAL_64): INTEGER
		local
			i, bits_1_8, bits_9_16, bits_17_24, bits_25_32, bits_33_40, bits_41_48, bits_49_56, bits_57_64: INTEGER
		do
			if attached Precomputed_pop_count as pop_count then
				bits_1_8 := (n & 0xFF).to_integer_32
				bits_9_16 := ((n |>> 8) & 0xFF).to_integer_32
				bits_17_24 := ((n |>> 16) & 0xFF).to_integer_32
				bits_25_32 := ((n |>> 24) & 0xFF).to_integer_32
				bits_33_40 := ((n |>> 32) & 0xFF).to_integer_32
				bits_41_48 := ((n |>> 40) & 0xFF).to_integer_32
				bits_49_56 := ((n |>> 48) & 0xFF).to_integer_32
				bits_57_64 := ((n |>> 56) & 0xFF).to_integer_32

				Result := pop_count [bits_1_8] + pop_count [bits_9_16]
							+ pop_count [bits_17_24] + pop_count [bits_25_32]
							+ pop_count [bits_33_40] + pop_count [bits_41_48]
							+ pop_count [bits_49_56] + pop_count [bits_57_64]
			end
		ensure
			same_as_built_in: Result = gcc_ones_count_64 (n)
		end

	frozen precomputed_ones_count_64_v3 (n: NATURAL_64): INTEGER
		local
			i: INTEGER
		do
			if attached Precomputed_pop_count as pop_count then
				from i := 0 until i > 56 loop
					Result := Result + pop_count [((n |>> i) & 0xFF).to_integer_32]
					i := i + 8
				end
			end
		ensure
			same_as_built_in: Result = gcc_ones_count_64 (n)
		end

	frozen slow_ones_count_64 (a_bitmap: NATURAL_64): INTEGER
		-- count of 1's in `bitmap' without using gcc built-in
		local
			leading_count, trailing_count, zero_count: INTEGER; skip_ones: BOOLEAN
			bitmap: NATURAL_64
		do
			if a_bitmap.to_boolean then
				leading_count := leading_zeros_count_64 (a_bitmap)
				trailing_count := trailing_zeros_count_64 (a_bitmap)
				Result := 64 - leading_count - trailing_count
				skip_ones := True
				from bitmap := a_bitmap |>> trailing_count until bitmap = bitmap.zero loop
					if skip_ones then
						zero_count := trailing_zeros_count_64 (bitmap.bit_not) -- skip ones
					else
						zero_count := trailing_zeros_count_64 (bitmap) -- skip zeros
						Result := Result - zero_count
					end
					skip_ones := not skip_ones
					bitmap := bitmap |>> zero_count
				end
			end
		end

end