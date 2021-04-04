note
	description: "Code performance benchmarking routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:30:36 GMT (Sunday 4th April 2021)"
	revision: "6"

class
	EL_BENCHMARK_ROUTINES

inherit
	ANY

	EL_MODULE_MEMORY

	EL_MODULE_TUPLE

feature {NONE} -- Implementation

	comparative_millisecs_string (a, b: DOUBLE): STRING
		do
			Result := comparative_string (a, b, once "ms")
		end

	comparative_string (a, b: DOUBLE; units: STRING): STRING
		do
			if a = b then
				create Result.make (10 + units.count + 1)
				Result.append (Double.formatted (a))
				Result.append_character (' ')
				Result.append (units)
			else
				Result := relative_percentage_string (a, b)
			end
		end

	integer_comparison_string (a, b: INTEGER; units: STRING; format: FORMAT_INTEGER): ZSTRING
		do
			if a = b then
				Result := Template_for_same #$ [a, units]
			else
				Result := Template_for_different #$ [a, units, relative_percentage_string (a, b)]
			end
		end

	relative_percentage_string (a, b: DOUBLE): STRING
		local
			percent: INTEGER
		do
			percent := relative_percentage (a, b)
			Result := percent.out + "%%"
			if percent >= 0 then
				Result.prepend_character ('+')
			end
		end

	relative_percentage (a, b: DOUBLE): INTEGER
		do
			if a < b then
				Result := ((b - a) / -b * 100.0).rounded
			else
				Result := ((a - b) / a * 100.0).rounded
			end
		end

	application_count (timer: EL_EXECUTION_TIMER; action: ROUTINE; trial_duration: DOUBLE): INTEGER
		-- number of times that `action' can be applied within the `trial_duration' in milliseconds
		do
			from timer.start until timer.elapsed_millisecs > trial_duration loop
				action.apply
				Result := Result + 1
			end
			timer.stop
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 3)
		end

	Template_for_same: ZSTRING
		once
			Result := "%S %S"
		end

	Template_for_different: ZSTRING
		once
			Result := "%S %S (%S)"
		end
end