note
	description: "Do nothing progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-16 9:48:27 GMT (Sunday 16th June 2019)"
	revision: "4"

class
	EL_DEFAULT_PROGRESS_LISTENER

inherit
	EL_PROGRESS_LISTENER
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			create {EL_DEFAULT_PROGRESS_DISPLAY} display
		end

feature {NONE} -- Implementation

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

	set_progress (proportion: DOUBLE)
		do
		end

	on_time_estimation (a_seconds: INTEGER)
		do
		end

	on_finish
		do
		end

end
