note
	description: "File progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_FILE_PROGRESS_DISPLAY

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

feature -- Factory

	new_progress_listener: EL_FILE_PROGRESS_LISTENER
		do
			create Result.make (Current)
		end

feature {EL_NOTIFYING_FILE, EL_FILE_PROGRESS_LISTENER, EL_FILE_PROGRESS_DISPLAY,  EL_SHARED_FILE_PROGRESS_LISTENER}
	-- Event handling

	on_finish
		deferred
		end

	on_start (bytes_per_tick: INTEGER)
		deferred
		end

end
