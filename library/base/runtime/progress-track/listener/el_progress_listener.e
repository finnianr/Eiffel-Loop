note
	description: "Operation progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-07 17:50:09 GMT (Monday 7th March 2022)"
	revision: "3"

class
	EL_PROGRESS_LISTENER

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

	reset
		do
			tick_count := 0
		end

feature {NONE} -- Internal attributes

	tick_count: INTEGER
		-- number of times set_progress has been called

	final_tick_count: INTEGER

end