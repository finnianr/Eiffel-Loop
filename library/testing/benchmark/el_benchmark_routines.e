note
	description: "Code performance benchmarking routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:39:11 GMT (Sunday 26th December 2021)"
	revision: "11"

expanded class
	EL_BENCHMARK_ROUTINES

inherit
	EL_EXPANDED_ROUTINES


	EL_MODULE_MEMORY

feature -- Access

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

	application_count (action: ROUTINE; trial_duration: INTEGER): INTEGER
		-- number of times that `action' can be applied within the `trial_duration' in milliseconds
		local
			timeout: EL_TIMEOUT_THREAD
		do
			create timeout.make (trial_duration)
			timeout.launch
			from until timeout.is_finished loop
				action.apply
				Memory.full_collect
				Result := Result + 1
			end
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 3)
		end

end