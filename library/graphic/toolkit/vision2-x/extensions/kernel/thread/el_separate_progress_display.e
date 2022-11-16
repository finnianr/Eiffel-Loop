note
	description: "[
		Progress display that forwards calls from a monitored thread separate to main GUI thead
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_SEPARATE_PROGRESS_DISPLAY

inherit
	EL_PROGRESS_DISPLAY

	EL_MODULE_ACTION

create
	make

feature {NONE} -- Initialization

	make (a_display: like display)
		do
			display := a_display
		end

feature {EL_NOTIFYING_FILE} -- Event handling

	on_finish
		do
			call (agent display.on_finish)
		end

	on_start (bytes_per_tick: INTEGER)
		do
			call (agent display.on_start (bytes_per_tick))
		end

feature -- Basic operations

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			call (agent display.set_identified_text (id, a_text))
		end

	set_progress (proportion: DOUBLE)
		do
			call (agent display.set_progress (proportion))
		end

feature {NONE} -- Implementation

	call (an_action: PROCEDURE)
		do
			Action.do_once_on_idle (an_action)
		end

	display: EL_PROGRESS_DISPLAY
		-- GUI display display
end