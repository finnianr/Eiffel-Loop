note
	description: "Code performance benchmarking routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 10:05:42 GMT (Sunday 10th December 2023)"
	revision: "15"

expanded class
	EL_BENCHMARK_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_MODULE_MEMORY

	EL_SHARED_FORMAT_FACTORY

feature -- Access

	comparative_millisecs_string (a, b: DOUBLE): STRING
		do
			Result := comparative_string (a, b, once "ms")
		end

	comparative_string (a, b: DOUBLE; units: STRING): STRING
		do
			if a = b then
				create Result.make (10 + units.count + 1)
				Result.append (Format.double_as_string (a, once "99.999"))
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

	application_count (action: ROUTINE; trial_duration: INTEGER): NATURAL_64
		-- number of times that `action' can be applied within the `trial_duration' in milliseconds
		local
			timeout: EL_TIMEOUT_THREAD
		do
			create timeout.make (trial_duration)
			timeout.launch
			from until timeout.is_finished loop
				action.apply
				Result := Result + 1
			end
		end

feature {NONE} -- Constants

	Timer: EL_EXECUTION_TIMER
		once
			create Result.make
		end
end