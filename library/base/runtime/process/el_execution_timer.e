note
	description: "Calculates elapsed time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-12 17:54:42 GMT (Monday 12th June 2017)"
	revision: "4"

class EL_EXECUTION_TIMER

inherit
	TIME_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create time_list.make (1)
			create duration_list.make (2)
		end

feature -- Access

	elapsed_millisecs: INTEGER
			--
		do
			Result := (elapsed_time.fine_seconds_count * 1000.0).rounded
		end

	elapsed_time: EL_DATE_TIME_DURATION
		local
			was_timing: BOOLEAN
		do
			if is_timing then
				stop; was_timing := True
			end
			if duration_list.is_empty then
				create Result.make_zero
			else
				across duration_list as duration loop
					if duration.cursor_index = 1 then
						Result := duration.item
					else
						Result := Result + duration.item
					end
				end
			end
			if was_timing then
				resume
			end
		end

feature --Element change

	resume
		require
			not_is_timing: not is_timing
		do
			time_list.extend (new_time_now)
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
				duration_list.extend (new_time_now.relative_duration (time_list.last))
				time_list.wipe_out
			end
		end

feature -- Status query

	is_timing: BOOLEAN
		do
			Result := not time_list.is_empty
		end

feature {NONE} -- Implementation

	new_time_now: DATE_TIME
		do
			create Result.make_now
		end

feature {NONE} -- Internal attributes

	time_list: ARRAYED_LIST [DATE_TIME]

	duration_list: ARRAYED_LIST [EL_DATE_TIME_DURATION]

end

