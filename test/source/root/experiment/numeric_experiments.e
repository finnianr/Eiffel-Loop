note
	description: "Numeric experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-04 14:35:04 GMT (Thursday 4th November 2021)"
	revision: "5"

class
	NUMERIC_EXPERIMENTS

inherit
	EXPERIMENTAL

	DOUBLE_MATH
		rename
			pi as pi_double
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
			lio.put_double (0.1 + 0.2 - 0.3)
			lio.put_new_line

			lio.put_string (equation)
			lio.put_real ({REAL} 0.1 + {REAL} 0.2 - {REAL} 0.3)
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