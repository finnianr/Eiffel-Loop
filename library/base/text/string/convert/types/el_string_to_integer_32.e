note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 15:52:14 GMT (Wednesday 5th October 2022)"
	revision: "3"

class
	EL_STRING_TO_INTEGER_32

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_32]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `INTEGER_32'
		do
			Result := str.is_integer_32
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: INTEGER_32; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_integer_32 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_32
		do
			Result := str.to_integer_32
		end

end