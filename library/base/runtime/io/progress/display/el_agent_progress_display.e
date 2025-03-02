note
	description: "File progress display that calls a procedure on each progress update"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 13:34:23 GMT (Friday 7th July 2023)"
	revision: "1"

class
	EL_AGENT_PROGRESS_DISPLAY

inherit
	EL_PROGRESS_DISPLAY

create
	make

convert
	make ({PROCEDURE [DOUBLE]})

feature {NONE} -- Initialization

	make (notification_action: like notify)
		do
			notify := notification_action
		end

feature -- Element change

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
		end

	set_progress (proportion: DOUBLE)
		do
			notify (proportion)
		end

feature {NONE} -- Event handling

	on_finish
		do
		end

	on_start (tick_byte_count: INTEGER)
		do
		end

feature {NONE} -- Internal attributes

	notify: PROCEDURE [DOUBLE]

end