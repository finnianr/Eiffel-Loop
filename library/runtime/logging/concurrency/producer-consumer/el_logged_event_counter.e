note
	description: "[
		Intermittently log counting of timed event activity in thread classes like 
		[$source EL_REGULAR_INTERVAL_EVENT_PRODUCER] or [$source EL_CONSUMER]. Output frequency is determined
		by `Logs_per_minute' constant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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
