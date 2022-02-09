note
	description: "Sine wave created by adding together a list of multiplicands for x"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 0:06:06 GMT (Wednesday 9th February 2022)"
	revision: "4"

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