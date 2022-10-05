note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source REAL_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 15:54:45 GMT (Wednesday 5th October 2022)"
	revision: "3"

class
	EL_STRING_TO_REAL_32

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [REAL_32]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `REAL_32'
		do
			Result := str.is_real_32
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: REAL_32; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_real_32 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): REAL_32
		do
			Result := str.to_real_32
		end

end