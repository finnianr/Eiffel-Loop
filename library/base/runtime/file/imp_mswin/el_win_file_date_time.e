note
	description: "[
		Represents Windows file time as the number of 100-nanosecond intervals from 1 Jan 1601
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-01 10:45:43 GMT (Saturday 1st July 2023)"
	revision: "6"

class
	EL_WIN_FILE_DATE_TIME

inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		export
			{NONE} all
			{EL_WIN_FILE_INFO} item
		end

	EL_WIN_FILE_INFO_C_API
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_pointer (c_sizeof_FILETIME)
		end

feature -- Access

	unix_value: INTEGER
			-- number of seconds since Unix Epoch
		local
			nanosec_100: NATURAL_64
		do
			nanosec_100 := value
			Result := (nanosec_100 // Ten_micro_seconds_per_second - Secs_to_unix_epoch).to_integer_32
			if nanosec_100 \\ Ten_micro_seconds_per_second > Half_of_ten_micro_seconds_per_second then
				Result := Result + 1
			end
		end

	value: NATURAL_64
			-- number of 100 nanosecond intervals since 1 Jan 1601
			-- https://msdn.microsoft.com/en-us/library/windows/desktop/ms724284(v=vs.85).aspx
		do
			Result := c_filetime_high_word (item) |<< 32 | c_filetime_low_word (item)
		end

feature -- File query

	unix_file_time_creation (file_handle: NATURAL): INTEGER
		do
			call_succeeded := c_get_file_time (file_handle, item, Default_pointer, Default_pointer)
			if call_succeeded then
				Result := unix_value
			end
		ensure
			time_returned: call_succeeded
		end

	unix_file_time_last_access (file_handle: NATURAL): INTEGER
		do
			call_succeeded := c_get_file_time (file_handle, Default_pointer, item, Default_pointer)
			if call_succeeded then
				Result := unix_value
			end
		ensure
			time_returned: call_succeeded
		end

	unix_file_time_last_write (file_handle: NATURAL): INTEGER
		do
			call_succeeded := c_get_file_time (file_handle, Default_pointer, Default_pointer, item)
			if call_succeeded then
				Result := unix_value
			end
		ensure
			time_returned: call_succeeded
		end

feature -- File setting

	set_file_time_creation_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_unix_value (unix_date_time)
			call_succeeded := c_set_file_time (file_handle, item, Default_pointer, Default_pointer)
		ensure
			time_set: call_succeeded
		end

	set_file_time_last_access_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_unix_value (unix_date_time)
			call_succeeded := c_set_file_time (file_handle, Default_pointer, item, Default_pointer)
		ensure
			time_set: call_succeeded
		end

	set_file_time_last_write_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_unix_value (unix_date_time)
			call_succeeded := c_set_file_time (file_handle, Default_pointer, Default_pointer, item)
		ensure
			time_set: call_succeeded
		end

feature -- Element change

	set_unix_value (a_unix_value: INTEGER)
		local
			seconds_count: NATURAL_64
		do
			if a_unix_value < 0 then
				seconds_count := Secs_to_unix_epoch - a_unix_value.to_natural_64
			else
				seconds_count := Secs_to_unix_epoch + a_unix_value.to_natural_64
			end
			set_value (seconds_count * Ten_micro_seconds_per_second)
		ensure
			value_set: unix_value = a_unix_value
		end

	set_value (a_value: NATURAL_64)
		do
			c_set_filetime_low_word (item, a_value.to_natural_32)
			c_set_filetime_high_word (item, (a_value |>> 32).to_natural_32)
		end

feature {NONE} -- Internal attributes

	call_succeeded: BOOLEAN

feature {NONE} -- Constants

	Half_of_ten_micro_seconds_per_second: NATURAL_64 = 5_000_000

	Secs_to_unix_epoch: NATURAL_64 =	11_644_473_600
		-- since 1 Jan 1601

	Ten_micro_seconds_per_second: NATURAL_64 = 10_000_000

end