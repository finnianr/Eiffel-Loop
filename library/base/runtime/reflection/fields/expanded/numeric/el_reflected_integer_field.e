note
	description: "Field with type name pattern: NATURAL_* or INTEGER_*"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_REFLECTED_INTEGER_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_NUMERIC_FIELD [N]
		redefine
			set_directly
		end

feature -- Basic operations

	set_from_double (a_object: EL_REFLECTIVE; a_value: DOUBLE)
		deferred
		end

feature {NONE} -- Implementation

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		-- set from `DOUBLE' if string has decimal point
		do
			if string.has ('.') then
				set_from_double (a_object, string.to_double)
			else
				Precursor (a_object, string)
			end
		end

end