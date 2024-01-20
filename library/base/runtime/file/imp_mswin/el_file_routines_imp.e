note
	description: "Windows implementation of class ${EL_FILE_ROUTINES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "19"

class
	EL_FILE_ROUTINES_IMP

inherit
	EL_FILE_ROUTINES_I
		rename
			info as info_raw
		redefine
			make
		end

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create win_file_info.make
			create native_windows_path.make (0)
		end

feature {NONE} -- Implementation

	is_writable (file_path: FILE_PATH): BOOLEAN
		do
			if attached writable_info (file_path) as info then
				Result := info.is_open_write
				info.close
			end
		end

	is_readable (file_path: FILE_PATH): BOOLEAN
		do
			if attached readable_info (file_path) as info then
				Result := info.is_open_read
				info.close
			end
		end

	set_stamp (file_path: FILE_PATH; date_time: INTEGER)
		-- Stamp file with `time' (for both access and modification).
		do
			if attached writable_info (file_path) as info then
				info.set_unix_last_access_time (date_time)
				info.set_unix_last_write_time (date_time)
				info.close
			end
		end

	set_creation_time (file_path: FILE_PATH; date_time: INTEGER)
		-- set modification time with date_time as secs since Unix epoch
		do
			if attached writable_info (file_path) as info then
				info.set_unix_creation_time (date_time)
				info.close
			end
		end

	set_modification_time (file_path: FILE_PATH; date_time: INTEGER)
		-- set modification time with date_time as secs since Unix epoch
		do
			if attached writable_info (file_path) as info then
				info.set_unix_last_write_time (date_time)
				info.close
			end
		end

feature {NONE} -- Modified internal attributes

	readable_info (file_path: FILE_PATH): EL_WIN_FILE_INFO
		do
			Result := win_file_info
			Result.open_read (shared_native_path (file_path))
		end

	shared_native_path (file_path: FILE_PATH): MANAGED_POINTER
		do
			Result := native_windows_path
			internal_info_file.fill_native_path (Result, file_path)
		end

	writable_info (file_path: FILE_PATH): EL_WIN_FILE_INFO
		do
			Result := win_file_info
			Result.open_write (shared_native_path (file_path))
		end

feature {NONE} -- Internal attributes

	win_file_info: EL_WIN_FILE_INFO

	native_windows_path: MANAGED_POINTER

end