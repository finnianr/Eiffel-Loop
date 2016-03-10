note
	description: "Summary description for {EL_WEL_CONVERSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_WEL_CONVERSION

inherit
	WEL_SHARED_TEMPORARY_OBJECTS

feature -- Conversion

	string16_to_string8 (a_windows_str: POINTER): STRING
		local
			l_str: WEL_STRING
		do
			create l_str.make_by_pointer (a_windows_str)
			Result := l_str.string
		end

end
