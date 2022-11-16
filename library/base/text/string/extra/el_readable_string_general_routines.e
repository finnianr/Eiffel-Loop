note
	description: "Routines for classes conforming to [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_READABLE_STRING_GENERAL_ROUTINES

inherit
	EL_MODULE_CONVERT_STRING

feature -- Status query

	is_convertible (s: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		do
			Result := Convert_string.is_convertible (s, basic_type)
		end

feature -- Conversion

	to_type (str: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `basic_type'
		do
			Result := Convert_string.to_type (str, basic_type)
		end

feature -- Basic operations

	write_utf_8 (s: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		local
			i: INTEGER; c: EL_CHARACTER_32_ROUTINES
		do
			from i := 1 until i > s.count loop
				c.write_utf_8 (s [i], writeable)
				i := i + 1
			end
		end

feature -- Measurement

	maximum_count (strings: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
			--
		do
			across strings as str loop
				if str.item.count > Result then
					Result := str.item.count
				end
			end
		end

end