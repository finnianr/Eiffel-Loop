note
	description: "Base class for reflected fields of common expanded types"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:18:24 GMT (Monday 28th April 2025)"
	revision: "36"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD
		redefine
			value
		end

	EL_STRING_REPRESENTABLE_FIELD [G]
		undefine
			is_equal
		end

	EL_SHARED_CHARACTER_AREA_ACCESS

	EL_SHARED_UTF_8_SEQUENCE

feature -- Basic operations

	reset (object: ANY)
		do
			set_from_integer (object, 0)
		end

feature -- Access

	address (object: ANY): POINTER
		local
			offset: INTEGER
		do
			offset := {ISE_RUNTIME}.field_offset_of_type (index, object_type)
			Result := {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0) + offset
		end

	value (object: ANY): G
		deferred
		end

feature -- Conversion

	to_natural_64 (object: ANY): NATURAL_64
		deferred
		end

feature -- Status query

	has_string_representation: BOOLEAN
		do
			if representation /= Void then
				Result := attached {EL_STRING_FIELD_REPRESENTATION [ANY, ANY]} representation
			end
		end

	is_expanded: BOOLEAN
		do
			Result := True
		end

feature -- Comparison

	are_equal (a_current, other: ANY): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature -- Basic operations

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		deferred
		end

	set_from_utf_8 (object: ANY; utf_8: READABLE_STRING_8)
		local
			index_lower: INTEGER
		do
			inspect abstract_type
				when Character_32_type, Character_8_type then
					if attached Utf_8_sequence as sequence
						and then attached Character_area_8.get_lower (utf_8, $index_lower) as area
					then
						sequence.fill (area, index_lower)
						set_from_natural_64 (object, sequence.to_unicode)
					end
			else
				set_from_string (object, utf_8)
			end
		end

feature {NONE} -- Implementation

	append_value (string: STRING_GENERAL; a_value: G)
		deferred
		end

note
	descendants: "[
			EL_REFLECTED_EXPANDED_FIELD* [G]
				${EL_REFLECTED_BOOLEAN}
				${EL_REFLECTED_NUMERIC_FIELD* [N -> NUMERIC]}
					${EL_REFLECTED_REAL_32}
					${EL_REFLECTED_INTEGER_FIELD* [N -> NUMERIC]}
						${EL_REFLECTED_INTEGER_8}
						${EL_REFLECTED_INTEGER_32}
						${EL_REFLECTED_INTEGER_64}
						${EL_REFLECTED_NATURAL_8}
						${EL_REFLECTED_NATURAL_16}
						${EL_REFLECTED_NATURAL_32}
						${EL_REFLECTED_NATURAL_64}
						${EL_REFLECTED_INTEGER_16}
					${EL_REFLECTED_REAL_64}
				${EL_REFLECTED_CHARACTER_8}
				${EL_REFLECTED_CHARACTER_32}
				${EL_REFLECTED_POINTER}
	]"
end