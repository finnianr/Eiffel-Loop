note
	description: "[$source EL_SYSTEM_TIME] with elapsed time function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-15 10:02:30 GMT (Friday 15th December 2023)"
	revision: "4"

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

create
	make

feature -- Update

	update
		do
			Precursor
			last_milliseconds := day_milliseconds
		end

feature -- Measurement

	elapsed_millisecs: INTEGER
		local
			last, now: INTEGER
		do
			last := last_milliseconds
			update
			now := last_milliseconds
			if now < last then
				now := now + Milliseconds_in_day
			end
			Result := last_milliseconds - last
		end

end