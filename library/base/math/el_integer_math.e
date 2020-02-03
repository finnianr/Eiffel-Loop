note
	description: "Integer math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 17:16:45 GMT (Monday 3rd February 2020)"
	revision: "7"

class
	EL_INTEGER_MATH

feature -- Access

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

	digits (number: INTEGER): INTEGER
		do
			if number = number.zero then
				Result := 1
			else
				Result := Double_math.log10 (number.abs).floor + 1
			end
		end

feature {NONE} -- Constants

	Double_math: DOUBLE_MATH
		once
			create Result
		end

end
