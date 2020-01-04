note
	description: "Updateable file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-04 13:15:54 GMT (Saturday 4th January 2020)"
	revision: "5"

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
