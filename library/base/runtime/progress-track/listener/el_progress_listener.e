note
	description: "Operation progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-09 10:01:10 GMT (Saturday 9th November 2024)"
	revision: "5"

class EL_PROGRESS_LISTENER inherit ANY

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_display: EL_PROGRESS_DISPLAY; a_final_tick_count: INTEGER)
		do
			display := a_display
			final_tick_count := a_final_tick_count
		end

feature -- Access

	display: EL_PROGRESS_DISPLAY

feature -- Basic operations

	finish
		do
			display.set_progress (1.0)
			display.on_finish
			log_outcome ("tick_count", final_tick_count , tick_count)
			reset
		end

	notify_tick
		do
			if tick_count = 0 then
				display.on_start (final_tick_count)
			end
			tick_count := tick_count + 1
			display.set_progress (tick_count / final_tick_count)
		end

feature {NONE} -- Implementation

	log_outcome (name: STRING; expected_count, actual_count: INTEGER)
		do
			if is_lio_enabled then
				lio.put_string (display.generator)
				lio.put_spaces (1)
				lio.put_integer_field (name, actual_count)
				if actual_count = expected_count then
					lio.put_string (" OK")
				else
					lio.put_integer_field (" Expected " + name, expected_count)
				end
				lio.put_new_line
			end
		end

	reset
		do
			tick_count := 0
		end

feature {NONE} -- Internal attributes

	tick_count: INTEGER
		-- number of times set_progress has been called

	final_tick_count: INTEGER

end