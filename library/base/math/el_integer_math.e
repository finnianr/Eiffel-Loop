note
	description: "Integer math routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-05 8:18:56 GMT (Thursday 5th September 2024)"
	revision: "17"

expanded class
	EL_INTEGER_MATH

inherit
	EL_EXPANDED_ROUTINES

feature -- INTEGER_64

	string_size (n: INTEGER_64): INTEGER
		do
			if n < 0 then
				Result := digit_count (n) + 1
			else
				Result := digit_count (n)
			end
		ensure
			definition: Result = n.out.count
		end

	digit_count (n: INTEGER_64): INTEGER
		do
			Result := natural_digit_count (n.abs.to_natural_64)
		end

feature -- NATURAL_64

	hash_key (n: INTEGER_32; n_array: SPECIAL [INTEGER_32]): NATURAL_64
		-- unique digest of numbers `n' and `n_array'
		local
			i: INTEGER
		do
			Result := n.to_natural_64 * Big_prime
			from i := 0 until i = n_array.count loop
				Result := Result.bit_xor (n_array [i].to_natural_64) * Big_prime
				i := i + 1
			end
		end

	natural_digit_count (n: NATURAL_64): INTEGER
		-- benchmarked to be twice as fast as using {DOUBLE_MATH}.log10
		local
			quotient: NATURAL_64
		do
			inspect n
				when 0 then
					Result := 1
			else
				from quotient := n until quotient = 0 loop
					Result := Result + 1
					quotient := quotient // 10
				end
			end
		ensure
			definition: Result = n.out.count
		end

feature -- INTEGER_32

	modulo (number, modulus: INTEGER): INTEGER
		do
			Result := number \\ modulus
			if Result < 0 then
				Result := Result + modulus
			end
		end

	rounded (number, n: INTEGER): INTEGER
		-- number rounded to n significant digit_count
		local
			count, zeros, divisor: INTEGER
		do
			count := digit_count (number)
			zeros := count - count.min (n)
			if zeros > 0 then
				divisor := (10 ^ zeros).rounded
				Result := number // divisor
				if number \\ divisor > divisor // 2 then
					Result := Result + 1
				end
				Result := Result * divisor
			else
				Result := number
			end
		end

feature {NONE} -- Constants

	Big_prime: NATURAL_64 = 11400714819323198485

end