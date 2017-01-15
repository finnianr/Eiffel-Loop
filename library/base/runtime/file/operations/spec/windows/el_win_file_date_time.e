note
	description: "[
		Converts a Windows FILETIME structure to Unix date stamp
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-15 15:27:13 GMT (Sunday 15th January 2017)"
	revision: "1"

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

	since_unix_epoch: INTEGER
			-- number of seconds since Unix Epoch
		local
			l_100_nano: NATURAL_64
		do
			-- Convert number of 100-nanosecond intervals since Unix Epoch
			-- https://msdn.microsoft.com/en-us/library/windows/desktop/ms724284(v=vs.85).aspx

			l_100_nano := c_filetime_high_word (item) |<< 32 | c_filetime_low_word (item)
			Result := (l_100_nano // Ten_micro_seconds_per_second - Secs_to_unix_epoch).to_integer_32
			if l_100_nano \\ Ten_micro_seconds_per_second > Half_of_ten_micro_seconds_per_second then
				Result := Result + 1
			end
		end

feature {NONE} -- Constants

	Ten_micro_seconds_per_second: NATURAL_64 = 10_000_000

	Half_of_ten_micro_seconds_per_second: NATURAL_64 = 5_000_000

	Secs_to_unix_epoch: NATURAL_64 =	11_644_473_600
		-- since 1 Jan 1601
end
