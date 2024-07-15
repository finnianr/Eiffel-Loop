note
	description: "Numeric experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 17:24:32 GMT (Monday 15th July 2024)"
	revision: "19"

class
	NUMERIC_TEST_SET

inherit
	EL_EQA_TEST_SET

	DOUBLE_MATH
		rename
			pi as pi_double
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["double_string_conversion", agent test_double_string_conversion],
				["integer_width",				  agent test_integer_width],
				["negative_to_natural",		  agent test_negative_to_natural],
				["store_integer_in_natural", agent test_store_integer_in_natural],
				["truncated_natural_64",	  agent test_truncated_natural_64]
			>>)
		end

feature -- Tests

	test_double_string_conversion
		-- NUMERIC_TEST_SET.test_double_string_conversion
		local
			d1, d2, r64: DOUBLE; r32: REAL
			n: INTEGER
		do
			d1 := 3.3;
			across << "3.3000000000000003", "3.3" >> as str loop
				d2 := str.item.to_double
				if str.cursor_index = 1 then
					assert ("same number", d1 /= d2)
				else
					assert ("same number", d1 = d2)
				end
			end
			n := 1
			across 1 |..| 9 as i loop
				r64 := n.to_double + (1 / i.item); r32 := r64.truncated_to_real

				lio.put_labeled_substitution (i.item.out, "double: %S real: %S", [r64, r32])
				lio.put_new_line
				n := n * 10
			end
		end

	test_integer_width
		-- NUMERIC_TEST_SET.test_integer_width
		do
			assert ("width is 3", log10 (999).floor + 1 = 3)
			assert ("width is 4", log10 (1000).floor + 1 = 4)
		end

	test_negative_to_natural
		local
			i: INTEGER; n: NATURAL
		do
			i := -2
			n := i.to_natural_32
			assert ("same as abs", n = 4294967294)

			-- reverse
			i := n.to_integer_32
			assert ("same as abs", i = -2)
		end

	test_store_integer_in_natural
		-- NUMERIC_TEST_SET.test_store_integer_in_natural
		local
			natural_64: NATURAL_64; i: INTEGER
		do
			i := -1
			natural_64 := i.to_natural_64
			i := natural_64.to_integer_32
			assert ("recovered i", i = -1)
		end

	test_truncated_natural_64
		local
			natural_64: NATURAL_64
		do
			natural_64 := 0xFFFFFFFF
			assert ("same string", natural_64.to_natural_16.to_hex_string ~ "FFFF")
		end

feature -- Basic operations

	abstract_increment
		local
			n: INTEGER_16; number: NUMERIC
		do
			n := 1
			number := n
			number := number + number.one
			lio.put_labeled_string ("number", number.out)
		end

	generic_numeric
		local
			edge: EDGE [INTEGER]
		do
			create edge
			lio.put_integer_field ("One", edge.cost)
			lio.put_new_line
		end

	hex_conversion
		local
			n: NATURAL_64
		do
			n := 0xAAAABBBBCCCCDDDD
			lio.put_labeled_string ("to_hex_string", n.to_hex_string)
		end

	iteration_10_to_pow_8
		local
			capacity: INTEGER_64
		do
			from capacity := 10 until capacity >= 100_000_000 loop
				lio.put_labeled_string ("capacity", capacity.out)
				lio.put_new_line
				capacity := capacity * 10
			end
		end

	log_sequence
		local
			n, i: INTEGER
		do
			from n := 1; i := 1 until i > 29 loop
				lio.put_integer_field ("log " + n.out, log10 (n).ceiling.max (1))
				lio.put_new_line
				i := i + 1
				n := n * 2
			end
		end

	negative_integer_32_in_integer_64
			-- is it possible to store 2 negative INTEGER_32's in one INTEGER_64
		local
			n: INTEGER_64
		do
			n := ((10).to_integer_64 |<< 32) | -10
			lio.put_integer_field ("low", n.to_integer_32) -- yes you can
			lio.put_integer_field (" hi", (n |>> 32).to_integer_32) -- yes you can
		end

	pi: DOUBLE
			-- Given that Pi can be estimated using the function 4 * (1 - 1/3 + 1/5 - 1/7 + ..)
			-- with more terms giving greater accuracy, write a function that calculates Pi to
			-- an accuracy of 5 decimal places.
		local
			limit, term, four: DOUBLE; divisor: INTEGER
		do
			lio.enter ("pi")
			four := 4.0; limit := 0.5E-5; divisor := 1
			from term := four until term.abs < limit loop
				Result := Result + term
				four := four.opposite
				divisor := divisor + 2
				term := four / divisor
			end
			lio.put_integer_field ("divisor", divisor)
			lio.put_new_line
			lio.exit
		end

	raku_vs_eiffel
		-- Raku gives correct answer for following
		local
			equation: STRING
		do
			equation :="x = 0.1 + 0.2 - 0.3 => x = "
			lio.put_string (equation)
			lio.put_double (0.1 + 0.2 - 0.3, Void)
			lio.put_new_line

			lio.put_string (equation)
			lio.put_real ({REAL} 0.1 + {REAL} 0.2 - {REAL} 0.3, Void)
			lio.put_new_line

			lio.put_string (equation + ({REAL} 0.01 + {REAL} 0.02 - {REAL} 0.03).out)
			lio.put_new_line
		end

	random_sequence
			--
		local
			random: RANDOM; odd, even: INTEGER; time: TIME
		do
			create time.make_now
			create random.make
			random.set_seed (time.compact_time)
			lio.put_integer_field ("random.seed", random.seed)
			lio.put_new_line
			from  until random.index > 200 loop
				lio.put_integer_field (random.index.out, random.item)
				lio.put_new_line
				if random.item \\ 2 = 0 then
					even := even + 1
				else
					odd := odd + 1
				end
				random.forth
			end
			lio.put_new_line
			lio.put_integer_field ("odd", odd)
			lio.put_new_line
			lio.put_integer_field ("even", even)
			lio.put_new_line
		end

	real_rounding
		local
			r: REAL
		do
			r := ("795").to_real
			lio.put_integer_field ("(r * 100).rounded", (r * 100).rounded)
		end

end