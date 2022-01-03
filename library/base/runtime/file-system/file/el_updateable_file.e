note
	description: "Updateable file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "7"

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

	modification_time: EL_DATE_TIME
		do
			if path.exists then
				Result := path.modification_date_time
			else
				Result := last_modification_time.twin
				last_modification_time.day_add (-1)
			end
		end

feature -- Access

	path: FILE_PATH

end