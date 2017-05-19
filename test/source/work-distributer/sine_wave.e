note
	description: "Summary description for {SINE_WAVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-19 7:00:59 GMT (Friday 19th May 2017)"
	revision: "1"

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
