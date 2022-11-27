note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source REAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_STRING_TO_REAL_64

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [REAL_64]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `REAL_64'
		do
			Result := str.is_real_64
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: REAL_64; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_real_64 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): REAL_64
		do
			Result := str.to_real_64
		end

end