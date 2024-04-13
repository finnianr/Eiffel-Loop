note
	description: "Integer math routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-13 9:39:07 GMT (Saturday 13th April 2024)"
	revision: "15"

expanded class
	EL_INTEGER_MATH

inherit
	EL_EXPANDED_ROUTINES

feature -- Measurement

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

	natural_digit_count (n: NATURAL_64): INTEGER
		-- twice as fast as using {DOUBLE_MATH}.log10
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

feature -- Access

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

end