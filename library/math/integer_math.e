note
	description: "Summary description for {INTEGER_MATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
