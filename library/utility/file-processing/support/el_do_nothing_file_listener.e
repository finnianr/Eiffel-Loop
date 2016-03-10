note
	description: "Summary description for {DO_NOTHING_SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:55:27 GMT (Wednesday 13th March 2013)"
	revision: "2"

class
	EL_DO_NOTHING_FILE_LISTENER

inherit
	EL_FILE_PROGRESS_LISTENER

create
	default_create

feature {NONE} -- Implementation

	set_text (a_text: EL_ASTRING)
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
