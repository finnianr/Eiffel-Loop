note
	description: "Operation progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 11:20:38 GMT (Thursday   26th   September   2019)"
	revision: "7"

deferred class
	EL_PROGRESS_DISPLAY

feature -- Element change

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		deferred
		end

	set_progress (proportion: DOUBLE)
		deferred
		end

	set_text (a_text: ZSTRING)
		do
			set_identified_text (0, a_text)
		end

feature {EL_PROGRESS_LISTENER, EL_PROGRESS_DISPLAY}
	-- Event handling

	on_finish
		deferred
		end

	on_start (bytes_per_tick: INTEGER)
		deferred
		end

end
