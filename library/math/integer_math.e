note
	description: "Summary description for {INTEGER_MATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-17 14:24:57 GMT (Sunday 17th May 2015)"
	revision: "3"

class
	INTEGER_MATH

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
			Result := Double_math.log10 (number).floor + 1
		end

feature {NONE} -- Constants

	Double_math: DOUBLE_MATH
		once
			create Result
		end

end
