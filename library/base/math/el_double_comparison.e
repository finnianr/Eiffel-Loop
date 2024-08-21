note
	description: "Comparison of ${ARRAY [REAL_64]} instances"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-21 7:50:56 GMT (Wednesday 21st August 2024)"
	revision: "10"

class
	EL_DOUBLE_COMPARISON

inherit
	DOUBLE_MATH
		rename
			log as log_e
		end

feature -- Comparison	

	arrays_equal (array_1, array_2: ARRAY [DOUBLE]): BOOLEAN
			--
		do
			Result := arrays_equal_by_comparison (array_1, array_2, agent exactly_equal)
		end

	arrays_nearly_equal (array_1, array_2: ARRAY [DOUBLE]): BOOLEAN
			--
		do
			Result := arrays_equal_by_comparison (array_1, array_2, agent close_enough)
		end

	arrays_equal_by_comparison (
		array_1, array_2: ARRAY [DOUBLE]; comparison: FUNCTION [DOUBLE, DOUBLE, BOOLEAN]
	): BOOLEAN
			--
		local
			i: INTEGER
			difference_found: BOOLEAN
		do
			if array_intervals_equal (array_1, array_2) then
				from i := array_1.lower until i > array_1.upper or difference_found loop
					if not comparison.item ([array_1 [i], array_2 [i]]) then
						difference_found := true
					else
						i := i + 1
					end
				end
				Result := not difference_found
			end
		end

	array_intervals_equal (array_1, array_2: ARRAY [DOUBLE]): BOOLEAN
			--
		do
			if array_1.lower = array_2.lower and array_1.upper = array_2.upper then
				Result := true
			end
		end

	close_enough (a, b: DOUBLE): BOOLEAN
			--
		do
			Result := (a - b).abs < Comparison_tolerance
		end

	exactly_equal (a, b: DOUBLE): BOOLEAN
			--
		do
			Result := a = b
		end

	significant (d: DOUBLE; digits: INTEGER): INTEGER_64
			-- Significant digits
		local
			n_shift: DOUBLE
		do
			n_shift := digits - log10 (d).floor
			Result := (d * 10 ^ n_shift).rounded_real_64.truncated_to_integer_64
		end

feature {NONE} -- Constants

	Comparison_tolerance: DOUBLE
			--
		once
			Result := 1.0e-12
		end

end