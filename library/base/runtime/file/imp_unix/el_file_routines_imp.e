note
	description: "Unix implementation of class [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-01 14:17:39 GMT (Saturday 1st July 2023)"
	revision: "15"

class
	EL_FILE_ROUTINES_IMP

inherit
	EL_FILE_ROUTINES_I

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	is_writable (a_path: FILE_PATH): BOOLEAN
		do
			Result := info (a_path, False).is_writable
		end

	set_modification_time (file_path: FILE_PATH; date_time: INTEGER)
		do
			info (file_path, False).set_date (date_time)
		end

	set_stamp (file_path: FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		do
			info (file_path, False).stamp (date_time)
		end

end