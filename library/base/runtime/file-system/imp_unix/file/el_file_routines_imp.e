note
	description: "Unix implementation of class [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "14"

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