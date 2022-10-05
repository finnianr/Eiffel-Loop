note
	description: "[
		Convert [$source READABLE_STRING_GENERAL] string to type conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 15:55:00 GMT (Wednesday 5th October 2022)"
	revision: "2"

deferred class
	EL_READABLE_STRING_GENERAL_TO_STRING_TYPE [G -> STRING_GENERAL]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [G]
		redefine
			new_type_description, type
		end

feature -- Access

	type: TYPE [STRING_GENERAL]

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: G; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_reference (value, index)
		end

feature {NONE} -- Implementation

	new_type_description: STRING
		-- terse English language description of type
		do
			if type ~ {STRING} then
				Result := "latin-1 string"
			else
				Result := "unicode string"
			end
		end
end