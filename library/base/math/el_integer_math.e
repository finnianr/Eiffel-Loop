note
	description: "Integer math routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-19 16:58:17 GMT (Monday 19th February 2024)"
	revision: "13"

expanded class
	EL_INTEGER_MATH

inherit
	EL_EXPANDED_ROUTINES

feature -- Access

	digits (n: INTEGER): INTEGER
		local
			double: EL_DOUBLE_MATH
		do
			Result := double.digit_count (n.to_natural_64)
		end

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
			digit_count, zeros, divisor: INTEGER
		do
			digit_count := digits (number)
			zeros := digit_count - digit_count.min (n)
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