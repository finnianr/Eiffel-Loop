note
	description: "Summary description for {EL_FILE_UPDATEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-25 7:55:14 GMT (Tuesday 25th April 2017)"
	revision: "1"

deferred class
	EL_UPDATEABLE_FILE

inherit
	EL_UPDATEABLE

feature {NONE} -- Initialization

	make (a_path: like path)
		do
			create last_modification_time.make_from_epoch (0)
			path := a_path
			update
		end

feature -- Access

	modification_time: DATE_TIME
		do
			if path.exists then
				Result := path.modification_date_time
			else
				Result := last_modification_time.twin
				last_modification_time.day_add (-1)
			end
		end

feature -- Access

	path: EL_FILE_PATH

end
