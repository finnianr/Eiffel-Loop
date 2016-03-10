note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_DOUBLE_COMPARISON

inherit
	DOUBLE_MATH
		rename
			log as log_e
		end

	EL_MODULE_LOG

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
		array_1, array_2: ARRAY [DOUBLE]
		comparison: FUNCTION [EL_DOUBLE_COMPARISON, TUPLE [DOUBLE, DOUBLE], BOOLEAN]
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
						log.enter ("arrays_equal")
						log.put_string ("Difference found in ")
						log.put_integer_interval_field ("range", array_1.lower |..| array_1.upper )
						log.put_new_line
						log.put_string ("array_1 [" + i.out + "]: ")
						log.put_double (array_1 [i])
						log.put_new_line
						log.put_string ("array_2 [" + i.out + "]: ")
						log.put_double (array_2.item (i))
						log.put_new_line
						log.exit
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
			else
				log.enter ("array_intervals_equal")
				log.put_line ("NOT EQUAL")
				log.put_integer_interval_field ("array_1", array_1.lower |..| array_1.upper)
				log.put_new_line
				log.put_integer_interval_field ("array_2", array_2.lower |..| array_2.upper)
				log.put_new_line
				log.exit
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
