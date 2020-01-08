note
	description: "Sine wave"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:28:58 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	SINE_WAVE

inherit
	DOUBLE_MATH

feature -- Access

	complex_sine_wave (x: DOUBLE; a_term_count: INTEGER): DOUBLE
		local
			i: INTEGER; multiplicand: DOUBLE
		do
			multiplicand := 1
			from i := 1 until i > a_term_count loop
				Result := Result + sine (multiplicand * x)
				multiplicand := multiplicand * 2
				i := i + 1
			end
		end
end
