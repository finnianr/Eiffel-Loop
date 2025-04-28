note
	description: "Field with type name pattern: NATURAL_* or INTEGER_*"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:19:37 GMT (Monday 28th April 2025)"
	revision: "3"

deferred class
	EL_REFLECTED_INTEGER_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_NUMERIC_FIELD [N]
		redefine
			set_directly
		end

feature -- Basic operations

	set_from_double (object: ANY; a_value: DOUBLE)
		deferred
		end

feature {NONE} -- Implementation

	set_directly (object: ANY; string: READABLE_STRING_GENERAL)
		-- set from `DOUBLE' if string has decimal point
		do
			if string.has ('.') then
				set_from_double (object, string.to_double)
			else
				Precursor (object, string)
			end
		end

end