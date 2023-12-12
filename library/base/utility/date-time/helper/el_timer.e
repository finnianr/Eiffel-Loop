note
	description: "[$source C_DATE] with time difference function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-12 15:58:44 GMT (Tuesday 12th December 2023)"
	revision: "1"

class
	EL_TIMER

inherit
	C_DATE
		rename
			make_utc as make
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

feature -- Update

	update
		local
			time_struct: POINTER; seconds: INTEGER
		do
			Precursor
			time_struct := internal_item.item
			seconds := get_tm_mday (time_struct) * Seconds_in_day
						 	+ get_tm_hour (time_struct) * Seconds_in_hour
							+ get_tm_min (time_struct) * Seconds_in_minute
							+ get_tm_sec (time_struct)

			last_milliseconds := seconds * 1000 + millisecond_now
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

feature {NONE} -- Internal attributes

	last_milliseconds: INTEGER
end