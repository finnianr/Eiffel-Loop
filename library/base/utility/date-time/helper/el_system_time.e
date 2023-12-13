note
	description: "A more efficient version [$source C_DATE] (less GC)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-13 15:44:15 GMT (Wednesday 13th December 2023)"
	revision: "1"

class
	EL_SYSTEM_TIME

inherit
	C_DATE
		rename
			internal_item as tm_struct
		redefine
			default_create, make_utc, update
		end

create
	make_local, make_utc

feature {NONE} -- Initialization

	default_create
			-- Create an instance of C_DATA using current local time.
		do
			create tm_struct.make (tm_structure_size)
			create union_timeb_time_t.make (timeb_structure_size + time_t_structure_size)
		end

	make_local
		do
			default_create
			update
		end

	make_utc
			-- Create an instance of C_DATE holding UTC values.
		do
			default_create; is_utc := True
			update
		end

feature -- Update

	update
		-- Pointer to `struct tm' area.
		local
			p_timeb, p_tm, p_time: POINTER; ms: INTEGER
		do
			p_timeb := union_timeb_time_t.item
			p_time := union_timeb_time_t.item + timeb_structure_size
			ftime (p_timeb)
			get_time (p_timeb, p_time)
			if is_utc then
				p_tm := gmtime (p_time)
			else
				p_tm := localtime (p_time)
			end
			tm_struct.item.memory_copy (p_tm, tm_structure_size)

			ms := get_millitm (p_timeb)
			if ms < 0 or ms > 999 then
				millisecond_now := 0
			else
				millisecond_now := ms
			end
		end

feature {NONE} -- Internal attributes

	union_timeb_time_t: MANAGED_POINTER
		-- area with `timeb' followed by `time_t' struct

end