note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${BOOLEAN}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_STRING_TO_BOOLEAN

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [BOOLEAN]
		redefine
			is_convertible
		end

create
	make

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `BOOLEAN'
		do
			Result := str.is_boolean
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: BOOLEAN; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_boolean (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.to_boolean
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		do
			across String_8_scope as scope loop
				Result := scope.copied_item (str).to_boolean
			end
		end

end