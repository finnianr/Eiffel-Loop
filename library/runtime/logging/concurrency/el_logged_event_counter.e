note
	description: "[
		Intermittently log counting of timed event activity in thread classes like 
		${EL_REGULAR_INTERVAL_EVENT_PRODUCER} or ${EL_CONSUMER}. Output frequency is determined
		by `Logs_per_minute' constant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_LOGGED_EVENT_COUNTER

inherit
	EL_MODULE_LOG

feature {NONE} -- Basic operations

	log_event
		do
			if elapsed_millisecs > next_time_to_log then
				log.enter_no_header ("log_event")
				next_time_to_log :=  next_time_to_log + (1000 / logs_per_second).rounded
				log.put_integer_field (count_label, count)
				log.put_new_line
				log.exit_no_trailer
			end
		end

feature {NONE} -- Implemenation

	elapsed_millisecs: INTEGER
		deferred
		end

	count_label: ZSTRING
		deferred
		end

	count: INTEGER
		deferred
		end

	reset
		do
			next_time_to_log := (1000 / logs_per_second).rounded
		end

	logs_per_second: DOUBLE
		do
			Result := Logs_per_minute / 60
		end

feature {NONE} -- Internal attributes

	next_time_to_log: INTEGER

feature {NONE} -- Constants

	Logs_per_minute: INTEGER
			-- Number of times per minute to log activity
		once
			Result := 80
		end

end