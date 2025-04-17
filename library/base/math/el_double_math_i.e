note
	description: "Integral and other double math routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 17:54:44 GMT (Tuesday 15th April 2025)"
	revision: "1"

deferred class
	EL_DOUBLE_MATH_I

inherit
	DOUBLE_MATH

	EL_ROUTINES

feature {NONE} -- Access

	percent (a, b: INTEGER): INTEGER
		-- `a' as a percentage of `b'
		do
			Result := (a * 100 / b).rounded
		end

feature {NONE} -- Basic operations

	integral (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE; delta_count: INTEGER): DOUBLE
		-- aproximate integral sum for function `f' within `lower' and `upper' bounds
		-- calculated with resolution `delta_count'
		require
			valid_bounds: lower < upper
			valid_resolution: delta_count >= 100
		local
			i: INTEGER; x, x_delta, x_distance: DOUBLE
		do
			x_distance := upper - lower
			x_delta := x_distance / delta_count
			from i := 1 until i > delta_count loop
				x := lower + x_distance * (i - 1) / delta_count
				Result := Result + (f (x) * x_delta).abs
				i := i + 1
			end
		end

	split_bounds (lower, upper: DOUBLE; count: INTEGER): ARRAYED_LIST [TUPLE [lower_, upper_: DOUBLE]]
			-- bounds split into `count' sub-bounds
		local
			full_x_distance: DOUBLE; i: INTEGER
		do
			create Result.make (count)
			full_x_distance := upper - lower
			from i := 1 until i > count loop
				Result.extend ([lower + full_x_distance * (i - 1) / count, upper - full_x_distance * (count - i) / count])
				i := i + 1
			end
		end

feature {NONE} -- Comparison

	approximately_equal (u, v, precision: DOUBLE): BOOLEAN
		local
			m, p: DOUBLE
		do
			m := u.abs.max (v.abs); p := m * precision
			Result := (u - v).abs < p
		end

end