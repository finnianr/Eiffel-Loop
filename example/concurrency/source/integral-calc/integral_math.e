note
	description: "Integral math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 14:33:34 GMT (Monday 21st April 2025)"
	revision: "6"

class INTEGRAL_MATH inherit ANY

	EL_DOUBLE_MATH_I
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