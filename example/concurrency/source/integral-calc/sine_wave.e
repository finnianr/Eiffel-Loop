note
	description: "Sine wave created by adding together a list of multiplicands for x"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	SINE_WAVE

inherit
	DOUBLE_MATH

feature -- Access

	complex_sine_wave (x: DOUBLE; multiplicand: SPECIAL [DOUBLE]): DOUBLE
		local
			i, count: INTEGER
		do
			count := multiplicand.count
			from i := 0 until i = count loop
				Result := Result + sine (x * multiplicand [i])
				i := i + 1
			end
		end
end