note
	description: "Calculates elapsed time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
			create elapsed_time.make_by_seconds (0)
		end

feature -- Basic operations

	start
			--
		do
			start_time.make_now
		end

	stop, update
			-- Update stop time to now
		do
			stop_time.make_now
			elapsed_time := stop_time.relative_duration (start_time)
		end

	elapsed_time: TIME_DURATION

	elapsed_millisecs: INTEGER
			--
		do
			if elapsed_time = Void then
				stop
			end
			Result := (elapsed_time.fine_seconds_count * 1000.0).rounded
		end

	elapsed_mins_and_secs_string: STRING
			--
		do
			if elapsed_time = Void then
				stop
			end
			create Result.make_empty
			Result.append_integer (elapsed_time.seconds_count // 60)
			Result.append (" mins ")
			Result.append_integer (elapsed_time.seconds_count \\ 60)
			Result.append (" secs ")
		end


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

feature {NONE} -- Implementation

	start_time: TIME

	stop_time: TIME

end -- class EL_TIMER

