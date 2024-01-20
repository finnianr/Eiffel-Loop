note
	description: "[
		Compare ${EL_SYSTEM_TIME} with ${C_DATE} for calculating milliseconds elapsed since
		mid night.
	]"
	notes: "[
		RESULTS: Calculate `day_milliseconds' 1000 times
		
			Passes over 500 millisecs (in descending order)

			EL_SYSTEM_TIME : 1903.0 times (100%)
			C_DATE         :  943.0 times (-50.4%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	SYSTEM_TIME_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	TIME_CONSTANTS

create
	make

feature -- Access

	Description: STRING = "EL_SYSTEM_TIME.day_milliseconds VS C_DATE"

feature -- Basic operations

	execute
		do
			compare ("Calculate `day_milliseconds' 1000 times", <<
				["C_DATE", agent do_method (1)],
				["EL_SYSTEM_TIME", agent do_method (2)]
			>>)
		end

feature {NONE} -- Operations

	do_method (method_id: INTEGER)
		local
			day_milliseconds, secs: INTEGER
		do
			across 1 |..| 1000 as n loop
				inspect method_id
					when 1 then
						if attached C_date as time then
							time.update
							secs := time.day_now * Seconds_in_day
									+ time.hour_now * Seconds_in_hour
									+ time.minute_now * Seconds_in_minute
									+ time.second_now

							day_milliseconds := secs * 1000 + time.millisecond_now
						end

					when 2 then
						System_time.update
						day_milliseconds := System_time.day_milliseconds
				end
			end
		end

feature {NONE} -- Constants

	C_date: C_DATE
		once
			create Result.make_utc
		end

	System_time: EL_SYSTEM_TIME
		once
			create Result.make_utc
		end

note
	notes: "[
		**13 Dec 2023**
		
		Passes over 500 millisecs (in descending order)

			System_time.update:	231.0 times (100%)
			C_date.update:			105.0 times (-54.5%)

	]"

end