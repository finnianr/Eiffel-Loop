note
	description: "Do nothing progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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