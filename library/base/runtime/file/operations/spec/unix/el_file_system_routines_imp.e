note
	description: "Unix implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:01:05 GMT (Wednesday 21st February 2018)"
	revision: "5"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

feature {NONE} -- Implementation

	escaped_path (path: EL_PATH): ZSTRING
		do
			Result := path.to_string
			Result.escape (Path_escaper)
		end

	set_file_modification_time (file_path: EL_FILE_PATH; date_time: INTEGER)
		do
			closed_raw_file (file_path).set_date (date_time)
		end

	set_file_stamp (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		do
			closed_raw_file (file_path).stamp (date_time)
		end

feature {NONE} -- Constants

	Path_escaper: EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER
		once
			create Result
		end
end
