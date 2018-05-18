note
	description: "Code performance benchmarking routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 9:47:36 GMT (Friday 18th May 2018)"
	revision: "3"

class
	EL_BENCHMARK_ROUTINES

feature {NONE} -- Implementation

	comparative_millisecs_string (a, b: DOUBLE): STRING
		do
			if a = b then
				Result := Double.formatted (a) + " ms"
			else
				Result := relative_percentage_string (a, b)
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

	average_execution (action: ROUTINE; application_count: INTEGER): DOUBLE
		local
			timer: EL_EXECUTION_TIMER; i: INTEGER
		do
			create timer.make
			timer.start
			from i := 1 until i > application_count loop
				action.apply
				Memory.collect
				i := i + 1
			end
			timer.stop
			Result := timer.elapsed_time.fine_seconds_count / application_count
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 3)
		end

	Memory: MEMORY
		once
			create Result
		end

end
