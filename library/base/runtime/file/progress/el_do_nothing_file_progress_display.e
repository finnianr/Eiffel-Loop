note
	description: "Do nothing file progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_DO_NOTHING_FILE_PROGRESS_DISPLAY

inherit
	EL_FILE_PROGRESS_DISPLAY

feature -- Element change

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

	set_progress (proportion: DOUBLE)
		do
		end

feature {EL_NOTIFYING_FILE, EL_FILE_PROGRESS_LISTENER,  EL_SHARED_FILE_PROGRESS_LISTENER} -- Event handling

	on_finish
		do
		end

	on_start (tick_byte_count: INTEGER)
		do
		end

end
