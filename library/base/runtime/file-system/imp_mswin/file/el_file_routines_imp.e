note
	description: "Windows implementation of class [$source EL_FILE_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 17:16:27 GMT (Monday 7th February 2022)"
	revision: "14"

class
	EL_FILE_ROUTINES_IMP

inherit
	EL_FILE_ROUTINES_I
		redefine
			make
		end

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create win_file_info.make
		end

feature {NONE} -- Implementation

	set_stamp (file_path: FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		do
			win_file_info.open_write (file_path)
			win_file_info.set_unix_last_access_time (date_time)
			win_file_info.set_unix_last_write_time (date_time)
			win_file_info.close
		end

	set_modification_time (file_path: FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		do
			win_file_info.open_write (file_path)
			win_file_info.set_unix_last_write_time (date_time)
			win_file_info.close
		end

feature {NONE} -- Internal attributes

	win_file_info: EL_WIN_FILE_INFO

end