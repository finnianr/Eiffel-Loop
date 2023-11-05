note
	description: "[
		Object that depends on an OS specific API call or command call for it's correct operation
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:09:01 GMT (Sunday 5th November 2023)"
	revision: "6"

deferred class
	EL_OS_DEPENDENT

feature -- Status query

	is_unix_implementation: BOOLEAN
		do
			Result := os_type = Unix_type
		end

	is_windows_implementation: BOOLEAN
		do
			Result := os_type = Windows_type
		end

feature -- Access

	os_type: NATURAL_8
		deferred
		end

feature {NONE} -- Constants

	Neutral_type: NATURAL_8 = 0

	Unix_type: NATURAL_8 = 1

	Windows_type: NATURAL_8 = 2
end