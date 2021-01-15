note
	description: "Do nothing file progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-14 10:08:52 GMT (Thursday 14th January 2021)"
	revision: "6"

class
	EL_DEFAULT_PROGRESS_DISPLAY

inherit
	EL_PROGRESS_DISPLAY

feature -- Element change

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
		end

	set_progress (proportion: DOUBLE)
		do
		end

feature {NONE} -- Event handling

	on_finish
		do
		end

	on_start (tick_byte_count: INTEGER)
		do
		end

end