note
	description: "Unix implementation of class [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:46:50 GMT (Monday 7th February 2022)"
	revision: "13"

class
	EL_FILE_ROUTINES_IMP

inherit
	EL_FILE_ROUTINES_I

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

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