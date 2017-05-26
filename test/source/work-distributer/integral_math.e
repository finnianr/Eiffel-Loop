note
	description: "Summary description for {SINE_WAVE_INTEGRAL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:21:04 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	INTEGRAL_MATH

inherit
	EL_DOUBLE_MATH
		rename
			integral as math_integral
		end

create
	make

feature {NONE} -- Initialization

	make (a_f: like f; a_lower, a_upper: DOUBLE; a_delta_count: INTEGER_32)
		do
			f := a_f; lower := a_lower; upper := a_upper; delta_count := a_delta_count
		end

feature -- Access

	integral: DOUBLE

feature -- Basic operations

	calculate
		do
			integral := math_integral (f, lower, upper, delta_count)
		end

feature {NONE} -- Internal attributes

	delta_count: INTEGER_32

	f: FUNCTION [DOUBLE, DOUBLE]

	lower, upper: DOUBLE

end
