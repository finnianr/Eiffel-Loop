note
	description: "Common expanded fields including BOOLEAN, POINTER and fields conforming to NUMERIC"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 12:27:11 GMT (Sunday 28th October 2018)"
	revision: "7"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD

	EL_SHARED_ONCE_STRINGS

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set_from_integer (a_object, 0)
		end

feature -- Access

	value (a_object: EL_REFLECTIVE): G
		do
			enclosing_object := a_object
			Result := field_value (index)
		end

	reference_value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

feature -- Status query

	is_expanded: BOOLEAN
		do
			Result := True
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature {NONE} -- Implementation

	field_value (i: INTEGER): G
		deferred
		end

end
