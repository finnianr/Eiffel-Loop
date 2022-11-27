note
	description: "[
		Represents Windows file time as the number of 100-nanosecond intervals from 1 Jan 1601
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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

feature -- Element change

	set_unix_value (a_unix_value: like unix_value)
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

	set_value (a_value: like value)
		do
			c_set_filetime_low_word (item, a_value.to_natural_32)
			c_set_filetime_high_word (item, (a_value |>> 32).to_natural_32)
		end

feature {NONE} -- Constants

	Ten_micro_seconds_per_second: NATURAL_64 = 10_000_000

	Half_of_ten_micro_seconds_per_second: NATURAL_64 = 5_000_000

	Secs_to_unix_epoch: NATURAL_64 =	11_644_473_600
		-- since 1 Jan 1601

end