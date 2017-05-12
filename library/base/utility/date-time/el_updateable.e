note
	description: "Summary description for {EL_UPDATEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-25 7:54:57 GMT (Tuesday 25th April 2017)"
	revision: "1"

deferred class
	EL_UPDATEABLE

feature -- Access

	modification_time: DATE_TIME
		deferred
		end

feature -- Basic operations

	update
		do
			do_update
			last_modification_time := modification_time
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := modification_time > last_modification_time
		end

feature {NONE} -- Implementation

	do_update
		deferred
		end

	last_modification_time: DATE_TIME
		-- time of last modification

end
