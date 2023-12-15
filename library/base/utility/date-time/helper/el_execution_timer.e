note
	description: "Calculates elapsed time for a maximum of a 24 hour period"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-15 11:12:01 GMT (Friday 15th December 2023)"
	revision: "11"

class EL_EXECUTION_TIMER

inherit
	EL_SYSTEM_TIME
		rename
			update as update_time
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_utc
			create time_area.make_empty (1)
		end

feature -- Access

	elapsed_millisecs: INTEGER
			--
		local
			was_timing: BOOLEAN
		do
			if is_timing then
				stop; was_timing := True
			end
			Result := elapsed_millisecs_sum
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

	reset
		require
			not_is_timing: not is_timing
		do
			elapsed_millisecs_sum := 0
		end

	set_elapsed_millisecs (millisecs: INTEGER)
		do
			elapsed_millisecs_sum := millisecs
		end

	start
		do
			reset; resume
		end

	stop, update
		-- Update stop time to now
		require
			is_timing: is_timing
		local
			now, previous: INTEGER
		do
			if is_timing then
				now := new_time_now; previous := time_area [0]
			--	in case mid night is passed
				if now < previous then
					now := now + Milliseconds_in_day
				end
				elapsed_millisecs_sum := elapsed_millisecs_sum + (now - previous)
				time_area.wipe_out
			end
		end

feature -- Status query

	is_timing: BOOLEAN
		do
			Result := time_area.count > 0
		end

feature {NONE} -- Implementation

	new_time_now: INTEGER
		do
			update_time
			Result := day_milliseconds
		end

feature {NONE} -- Internal attributes

	elapsed_millisecs_sum: INTEGER

	time_area: SPECIAL [INTEGER]

end