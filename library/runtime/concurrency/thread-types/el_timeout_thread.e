note
	description: "Timeout thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-05 16:01:37 GMT (Sunday 5th February 2023)"
	revision: "3"

class
	EL_TIMEOUT_THREAD

inherit
	EL_IDENTIFIED_THREAD
		export
			{NONE} all
			{ANY} launch
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

feature -- Status query

	is_finished: BOOLEAN

feature {NONE} -- Implementation

	execute
		do
			sleep (duration)
			is_finished := True
		end

end