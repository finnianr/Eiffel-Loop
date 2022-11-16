note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_16]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_STRING_TO_NATURAL_16

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [NATURAL_16]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `NATURAL_16'
		do
			Result := str.is_natural_16
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: NATURAL_16; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_natural_16 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): NATURAL_16
		do
			Result := str.to_natural_16
		end

end