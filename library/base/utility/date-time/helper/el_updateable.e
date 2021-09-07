note
	description: "Updateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-07 10:09:39 GMT (Tuesday 7th September 2021)"
	revision: "5"

deferred class
	EL_UPDATEABLE

feature -- Access

	modification_time: EL_DATE_TIME
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

	last_modification_time: EL_DATE_TIME
		-- time of last modification

end