note
	description: "A way to update ${C_DATE} without GC and memory allocation"
	descendants: "[
			EL_SYSTEM_TIME
				${EL_SYSTEM_TIMER}
				${EL_EXECUTION_TIMER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_SYSTEM_TIME

inherit
	C_DATE
		rename
			internal_item as tm_struct,
			millisecond_now as internal_millisecond_now,
			tm_structure_size as size_of_tm,
			timeb_structure_size as size_of_timeb,
			time_t_structure_size as size_of_time_t
		export
			{NONE} internal_millisecond_now
		redefine
			default_create, make_utc, update
		end

	TIME_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make_local, make_utc

feature {NONE} -- Initialization

	default_create
		-- allocate C memory
		do
			create tm_struct.make (size_of_tm)
			create union_timeb_time_t.make (size_of_timeb + size_of_time_t)
		end

	make_local
		do
			default_create
			update
		end

	make_utc
		do
			default_create; is_utc := True
			update
		end

feature -- Measurement

	day_milliseconds: INTEGER
		-- number of millisecs since midnight: 00:00:00.000
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

	millisecond_now: INTEGER
		-- current millisecond at creation time or after last call to `update'
		do
			Result := get_millitm (union_timeb_time_t.item)
			if Result < 0 or Result > 999 then
				Result := 0
			end
		end

feature -- Update

	update
		-- update `tm_struct' with current time
		local
			p_timeb, p_tm, p_time: POINTER
		do
			p_timeb := union_timeb_time_t.item
			p_time := p_timeb + size_of_timeb
			ftime (p_timeb); get_time (p_timeb, p_time)

			p_tm := tm_struct.item
			if is_utc then
				p_tm.memory_copy (gmtime (p_time), size_of_tm)
			else
				p_tm.memory_copy (localtime (p_time), size_of_tm)
			end
		end

feature {NONE} -- Internal attributes

	union_timeb_time_t: MANAGED_POINTER
		-- area with `timeb' followed by `time_t' struct

feature {NONE} -- Constants

	Milliseconds_in_day: INTEGER = 86400_000

end