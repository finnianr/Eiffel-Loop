note
	description: "Unix implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 12:08:31 GMT (Tuesday 5th January 2021)"
	revision: "11"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

create
	make

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := Path_escaper.escaped (s.as_zstring (path), True)
		end

	set_file_modification_time (file_path: EL_FILE_PATH; date_time: INTEGER)
		do
			info_file (file_path).set_date (date_time)
		end

	set_file_stamp (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		do
			info_file (file_path).stamp (date_time)
		end

feature {NONE} -- Constants

	Path_escaper: EL_BASH_PATH_ZSTRING_ESCAPER
		once
			create Result.make
		end

end