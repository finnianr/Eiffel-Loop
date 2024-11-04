note
	description: "Object that is updateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-04 10:20:45 GMT (Monday 4th November 2024)"
	revision: "8"

deferred class
	EL_UPDATEABLE

feature -- Access

	last_modification_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (last_modification_time)
		end

	last_modification_time: INTEGER
		-- Unix time of last modification

	modification_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (modification_time)
		end

	modification_time: INTEGER
		-- Unix modification time
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

end