note
	description: "Base class for reflected fields of common expanded types"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 12:18:32 GMT (Friday 9th December 2022)"
	revision: "20"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD

	EL_STRING_REPRESENTABLE_FIELD [G]
		undefine
			is_equal
		end

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

feature -- Status query

	is_expanded: BOOLEAN
		do
			Result := True
		end

	has_string_representation: BOOLEAN
		do
			Result := attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} representation
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: G)
		deferred
		end

	field_value (i: INTEGER): G
		deferred
		end

note
	descendants: "[
			EL_REFLECTED_EXPANDED_FIELD* [G]
				[$source EL_REFLECTED_NUMERIC_FIELD]* [N -> [$source NUMERIC]]
					[$source EL_REFLECTED_INTEGER_8]
					[$source EL_REFLECTED_INTEGER_16]
					[$source EL_REFLECTED_INTEGER_32]
					[$source EL_REFLECTED_INTEGER_64]
					[$source EL_REFLECTED_NATURAL_8]
					[$source EL_REFLECTED_NATURAL_32]
					[$source EL_REFLECTED_NATURAL_16]
					[$source EL_REFLECTED_REAL_32]
					[$source EL_REFLECTED_REAL_64]
					[$source EL_REFLECTED_NATURAL_64]
				[$source EL_REFLECTED_CHARACTER_8]
				[$source EL_REFLECTED_CHARACTER_32]
				[$source EL_REFLECTED_BOOLEAN]
				[$source EL_REFLECTED_POINTER]
	]"
end