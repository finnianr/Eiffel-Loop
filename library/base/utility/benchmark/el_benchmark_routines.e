note
	description: "Code performance benchmarking routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 9:12:57 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_BENCHMARK_ROUTINES

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

	average_execution (action: ROUTINE; apply_count: INTEGER): DOUBLE
		local
			timer: EL_EXECUTION_TIMER; i: INTEGER
		do
			create timer.make
			timer.start
			from i := 1 until i > apply_count loop
				action.apply
				Memory.full_collect
				i := i + 1
			end
			timer.stop
			Result := timer.elapsed_time.fine_seconds_count / apply_count
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
