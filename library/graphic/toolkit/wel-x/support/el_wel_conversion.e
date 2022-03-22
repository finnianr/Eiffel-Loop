note
	description: "Wel conversion"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-21 12:44:15 GMT (Monday 21st March 2022)"
	revision: "7"

deferred class
	EL_WEL_CONVERSION

inherit
	WEL_SHARED_TEMPORARY_OBJECTS

feature -- Conversion

	string_16_to_string_8 (a_windows_str: POINTER): STRING
		local
			l_str: WEL_STRING
		do
			create l_str.make_by_pointer (a_windows_str)
			Result := l_str.string
		end

end