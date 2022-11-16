note
	description: "Timeout thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_TIMEOUT_THREAD

inherit
	EL_IDENTIFIED_THREAD
		rename
			is_terminated as is_finished
		export
			{NONE} all
			{ANY} launch, is_finished
		end

create
	make
	
feature {NONE} -- Initialization

	make (a_duration: INTEGER)
		do
			make_default
			duration := a_duration
		end

feature -- Measurement

	duration: INTEGER
		-- duration to sleep in milliseconds

feature {NONE} -- Implementation

	execute
		do
			sleep (duration)
		end

end