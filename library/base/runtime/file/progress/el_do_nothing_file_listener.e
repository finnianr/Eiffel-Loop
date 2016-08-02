note
	description: "Summary description for {DO_NOTHING_SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:06:42 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_DO_NOTHING_FILE_LISTENER

inherit
	EL_FILE_PROGRESS_LISTENER

create
	make

feature {NONE} -- Implementation

	set_text (a_text: ZSTRING)
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