note
	description: "Compare methods to caculate population of 1's in [$source NATURAL_64]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			gcc built-in                                  :  7972126.0 times (100%)
			emulated with leading and trailing zero count :        6.0 times (-100.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 14:22:53 GMT (Monday 6th February 2023)"
	revision: "6"

class
	BIT_POP_COUNT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Compare bit population count methods"

feature -- Basic operations

	execute
		do
			compare (Description, <<
				["gcc built-in",	agent builtin_popcount],
				["emulated with leading and trailing zero count", agent emulated_popcount]
			>>)
		end

feature {NONE} -- Implementation

	builtin_popcount
		local
			count, shift: INTEGER; b: EL_BIT_ROUTINES
			n, i: NATURAL_64
		do
			from i := 0 until i > 0xFFFFF loop
				n := 0
				from shift := 0 until shift > 2 loop
					n := n | (i |<< shift * 20)
					shift := shift + 1
				end
				count := b.ones_count_64 (n)
				i := i + 1
			end
		end

	emulated_popcount
		local
			count, shift: INTEGER
			n, i: NATURAL_64
		do
			from i := 0 until i > 0xFFFFF loop
				n := 0
				from shift := 0 until shift > 2 loop
					n := n | (i |<< shift * 20)
					shift := shift + 1
				end
				count := ones_count_64 (n)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	frozen ones_count_64 (a_bitmap: NATURAL_64): INTEGER
		-- count of 1's in `bitmap'
		local
			leading_count, trailing_count, zero_count: INTEGER; skip_ones: BOOLEAN
			bitmap: NATURAL_64; b: EL_BIT_ROUTINES
		do
			if a_bitmap.to_boolean then
				leading_count := b.leading_zeros_count_64 (a_bitmap)
				trailing_count := b.trailing_zeros_count_64 (a_bitmap)
				Result := 64 - leading_count - trailing_count
				skip_ones := True
				from bitmap := a_bitmap |>> trailing_count until bitmap = bitmap.zero loop
					if skip_ones then
						zero_count := b.trailing_zeros_count_64 (bitmap.bit_not) -- skip ones
					else
						zero_count := b.trailing_zeros_count_64 (bitmap) -- skip zeros
						Result := Result - zero_count
					end
					skip_ones := not skip_ones
					bitmap := bitmap |>> zero_count
				end
			end
		end
end