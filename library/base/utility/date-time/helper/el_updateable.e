note
	description: "Object that is updateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 16:45:31 GMT (Tuesday 6th December 2022)"
	revision: "7"

deferred class
	EL_UPDATEABLE

feature -- Access

	last_modification_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (last_modification_time)
		end

	last_modification_time: INTEGER
		-- time of last modification

	modification_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (modification_time)
		end

	modification_time: INTEGER
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