note
	description: "Operation progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-16 11:46:56 GMT (Sunday 16th June 2019)"
	revision: "5"

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

feature -- Factory

	new_file_progress_listener (a_estimated_byte_count: INTEGER): EL_FILE_PROGRESS_LISTENER
		do
			create Result.make_estimated (Current, a_estimated_byte_count)
		end

	new_progress_listener (final_tick_count: INTEGER): EL_PROGRESS_LISTENER
		do
			create Result.make (Current, final_tick_count)
		end

feature {EL_NOTIFYING_FILE, EL_PROGRESS_LISTENER, EL_PROGRESS_DISPLAY,  EL_SHARED_FILE_PROGRESS_LISTENER}
	-- Event handling

	on_finish
		deferred
		end

	on_start (bytes_per_tick: INTEGER)
		deferred
		end

end
