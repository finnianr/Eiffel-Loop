note
	description: "[$source EL_SYSTEM_TIME] with elapsed time function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-13 17:17:22 GMT (Wednesday 13th December 2023)"
	revision: "3"

class
	EL_SYSTEM_TIMER

inherit
	EL_SYSTEM_TIME
		rename
			make_utc as make,
			internal_millisecond_now as last_milliseconds
		redefine
			update
		end

	TIME_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature -- Access

	day_milliseconds: INTEGER
		local
			p_tm: POINTER; seconds: INTEGER
		do
			p_tm := tm_struct.item
			seconds := get_tm_mday (p_tm) * Seconds_in_day
						 	+ get_tm_hour (p_tm) * Seconds_in_hour
							+ get_tm_min (p_tm) * Seconds_in_minute
							+ get_tm_sec (p_tm)

			Result := seconds * 1000 + millisecond_now
		end

feature -- Update

	update
		do
			Precursor
			last_milliseconds := day_milliseconds
		end

feature -- Measurement

	elapsed_millisecs: INTEGER
		local
			last: INTEGER
		do
			last := last_milliseconds
			update
			Result := last_milliseconds - last
		end

end