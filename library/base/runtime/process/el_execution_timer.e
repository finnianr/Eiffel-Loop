note
	description: "Calculates elapsed time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-10 11:56:51 GMT (Sunday 10th July 2022)"
	revision: "8"

class EL_EXECUTION_TIMER

inherit
	C_DATE
		rename
			update as update_time
		export
			{NONE} all
		end

	TIME_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			default_create
			create time_area.make_empty (1)
			create duration_list.make (2)
		end

feature -- Access

	elapsed_millisecs: DOUBLE
			--
		local
			was_timing: BOOLEAN
		do
			if is_timing then
				stop; was_timing := True
			end
			across duration_list as duration loop
				Result := Result + duration.item
			end
			if was_timing then
				resume
			end
		end

	elapsed_time: EL_TIME_DURATION
		do
			create Result.make_by_fine_seconds (elapsed_millisecs / 1000)
		end

feature --Element change

	resume
		require
			not_is_timing: not is_timing
		do
			time_area.extend (new_time_now)
		end

	start
			--
		do
			duration_list.wipe_out
			resume
		end

	stop, update
		-- Update stop time to now
		require
			is_timing: is_timing
		do
			if is_timing then
				duration_list.extend (new_time_now - time_area [0])
				time_area.wipe_out
			end
		end

	set_elapsed_millisecs (millisecs: DOUBLE)
		do
			duration_list.wipe_out
			duration_list.extend (millisecs)
		end

feature -- Status query

	is_timing: BOOLEAN
		do
			Result := time_area.count > 0
		end

feature {NONE} -- Implementation

	new_time_now: DOUBLE
		do
			update_time
			Result := day_now * Hours_in_day + hour_now
			Result := Result * Minutes_in_hour + minute_now
			Result := Result * Seconds_in_minute + second_now
			Result := Result * 1000 + millisecond_now
		end

feature {NONE} -- Internal attributes

	time_area: SPECIAL [DOUBLE]

	duration_list: ARRAYED_LIST [DOUBLE]

end