note
	description: "Calculates elapsed time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-14 11:45:09 GMT (Friday 14th October 2016)"
	revision: "2"

class EL_EXECUTION_TIMER

inherit
	ANY
		redefine
			out
		end

	TIME_CONSTANTS
		export
			{NONE} all
		undefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create start_time.make_now
			create stop_time.make_now
		end

feature -- Access

	elapsed_time: TIME_DURATION
		do
			if is_resumed then
				stop; resume
			end
			create Result.make_by_fine_seconds (elapased_fine_seconds_count)
		end

	elapsed_millisecs: INTEGER
			--
		do
			if is_resumed then
				stop; resume
			end
			Result := (elapased_fine_seconds_count * 1000.0).rounded
		end

	elapsed_mins_and_secs_string: STRING
			--
		local
			l_elapsed_time: like elapsed_time
		do
			l_elapsed_time := elapsed_time
			create Result.make_empty
			Result.append_integer (l_elapsed_time.seconds_count // 60)
			Result.append (" mins ")
			Result.append_integer (l_elapsed_time.seconds_count \\ 60)
			Result.append (" secs ")
		end

	elapased_fine_seconds_count: DOUBLE

	out: STRING
			--
		local
			millisecs: DOUBLE
		do
			if elapsed_time = Void then
				stop
			end
			create Result.make_empty
			millisecs := elapsed_time.fractional_second * 1000.0
			Result.append_string (elapsed_time.hour.out)
			Result.append_string (" hrs ")
			Result.append_integer (elapsed_time.minute)
			Result.append_string (" mins ")
			Result.append_integer (elapsed_time.second)
			Result.append_string (" secs ")
			Result.append_integer (millisecs.truncated_to_integer)
			Result.append_string (" ms")
		end

feature --Element change

	start
			--
		do
			elapased_fine_seconds_count := 0
			resume
		end

	resume
		do
			start_time.make_now
			is_resumed := True
		end

	stop, update
			-- Update stop time to now
		do
			stop_time.make_now
			elapased_fine_seconds_count := elapased_fine_seconds_count + stop_time.relative_duration (start_time).fine_seconds_count
			is_resumed := False
		end

feature -- Status query

	is_resumed: BOOLEAN

feature {NONE} -- Implementation

	start_time: TIME

	stop_time: TIME

end -- class EL_TIMER
