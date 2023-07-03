note
	description: "[
		Windows file date-time as the number of 100-nanosecond intervals from 1 Jan 1601
		with conversion routines for Unix time convention (secs from 1 Jan 1970)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 9:07:37 GMT (Monday 3rd July 2023)"
	revision: "7"

class
	EL_WIN_FILE_DATE_TIME

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			make_default as make,
			c_size_of as c_sizeof_FILETIME
		end

	EL_WIN_FILE_INFO_C_API
		undefine
			is_equal, copy
		end

create
	make

feature -- Access

	to_unix: INTEGER
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
			Result := c_filetime_high_word (self_ptr) |<< 32 | c_filetime_low_word (self_ptr)
		end

feature -- File query

	unix_file_time_creation (file_handle: NATURAL): INTEGER
		do
			Result := get_file_time (file_handle, 1)
		end

	unix_file_time_last_access (file_handle: NATURAL): INTEGER
		do
			Result := get_file_time (file_handle, 2)
		end

	unix_file_time_last_write (file_handle: NATURAL): INTEGER
		do
			Result := get_file_time (file_handle, 3)
		end

feature -- File setting

	set_file_time_creation_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_file_time (file_handle, unix_date_time, 1)
		end

	set_file_time_last_access_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_file_time (file_handle, unix_date_time, 2)
		end

	set_file_time_last_write_from_unix (file_handle: NATURAL; unix_date_time: INTEGER)
		do
			set_file_time (file_handle, unix_date_time, 3)
		end

feature -- Element change

	set_from_unix (a_unix_value: INTEGER)
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
			value_set: to_unix = a_unix_value
		end

	set_value (a_value: NATURAL_64)
		do
			c_set_filetime_low_word (self_ptr, a_value.to_natural_32)
			c_set_filetime_high_word (self_ptr, (a_value |>> 32).to_natural_32)
		end

feature {NONE} -- Implementation

	get_file_time (file_handle: NATURAL; argument_pos: INTEGER): INTEGER
		do
			get_set_file_time (file_handle, argument_pos, False)
			if call_succeeded then
				Result := to_unix
			end
		ensure
			unix_time_returned: call_succeeded
		end

	get_set_file_time (file_handle: NATURAL; argument_pos: INTEGER; setting: BOOLEAN)
		local
			i: INTEGER
		do
			if attached Pointer_array as a then
				i := argument_pos - 1; a [i] := self_ptr
				if setting then
					call_succeeded := c_set_file_time (file_handle, a [0], a [1], a [2])
				else
					call_succeeded := c_get_file_time (file_handle, a [0], a [1], a [2])
				end
				a [i] := default_pointer
			end
		ensure
			pointer_array_reset: pointer_array.filled_with (default_pointer, 0, 2)
		end

	set_file_time (file_handle: NATURAL; unix_date_time, argument_pos: INTEGER)
		do
			set_from_unix (unix_date_time)
			get_set_file_time (file_handle, argument_pos, True)
		ensure
			set_time_from_unix: call_succeeded
		end

feature {NONE} -- Internal attributes

	call_succeeded: BOOLEAN

feature {NONE} -- Constants

	Half_of_ten_micro_seconds_per_second: NATURAL_64 = 5_000_000

	Pointer_array: SPECIAL [POINTER]
		once
			create Result.make_filled (default_pointer, 3)
		end

	Secs_to_unix_epoch: NATURAL_64 =	11_644_473_600
		-- since 1 Jan 1601

	Ten_micro_seconds_per_second: NATURAL_64 = 10_000_000

end