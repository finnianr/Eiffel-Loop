note
	description: "Windows implementation of class [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:47:06 GMT (Monday 7th February 2022)"
	revision: "13"

class
	EL_FILE_ROUTINES_IMP

inherit
	EL_FILE_ROUTINES_I

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	set_stamp (file_path: FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		local
			l_info: like File_info
		do
			l_info := File_info
			l_info.open_write (file_path)
			l_info.set_unix_last_access_time (date_time)
			l_info.set_unix_last_write_time (date_time)
			l_info.close
		end

	set_modification_time (file_path: FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		local
			l_info: like File_info
		do
			l_info := File_info
			l_info.open_write (file_path)
			l_info.set_unix_last_write_time (date_time)
			l_info.close
		end

feature {NONE} -- Constants

	File_info: EL_WIN_FILE_INFO
		once
			create Result.make
		end

end