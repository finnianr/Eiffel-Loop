note
	description: "Operation progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 11:06:46 GMT (Thursday 9th September 2021)"
	revision: "9"

deferred class
	EL_PROGRESS_DISPLAY

feature -- Element change

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		deferred
		end

	set_progress (proportion: DOUBLE)
		deferred
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			set_identified_text (0, a_text)
		end

feature {EL_PROGRESS_LISTENER, EL_PROGRESS_DISPLAY}
	-- Event handling

	on_finish
		deferred
		end

	on_start (tick_byte_count: INTEGER)
		deferred
		end

end