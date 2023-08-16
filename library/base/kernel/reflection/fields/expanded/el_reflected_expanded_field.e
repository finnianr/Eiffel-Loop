note
	description: "Base class for reflected fields of common expanded types"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 12:21:36 GMT (Thursday 27th July 2023)"
	revision: "23"

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

	address (a_object: EL_REFLECTIVE): POINTER
		do
			enclosing_object := a_object
			Result := {ISE_RUNTIME}.raw_reference_field_at_offset ($enclosing_object, physical_offset)
			Result := Result + field_offset (index)
		end

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

feature {NONE} -- C External

--	field_class_name (i: INTEGER object_ptr: POINTER): POINTER
--		-- rt_private rt_inline char *ei_exp_type(long i, EIF_REFERENCE object)
--		-- Returns the class name of the i-th expanded field of `object'.
--		-- Workaround for eif_internal.h not being included in inlined code for `address' routine

--		external
--			"C (long, EIF_POINTER): EIF_POINTER | <eif_internal.h>"
--		alias
--			"ei_exp_type"
--		end

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