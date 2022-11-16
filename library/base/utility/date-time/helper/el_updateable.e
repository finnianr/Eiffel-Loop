note
	description: "Updateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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