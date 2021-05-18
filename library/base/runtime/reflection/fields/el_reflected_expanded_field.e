note
	description: "Common expanded fields including `BOOLEAN', `POINTER' and fields conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-18 17:01:53 GMT (Tuesday 18th May 2021)"
	revision: "13"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD
		redefine
			write_crc
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set_from_integer (a_object, 0)
		end

feature -- Access

	representation: EL_DATA_REPRESENTATION [G, ANY]
		-- object allowing text representation and conversion of field

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached representation as l_representation then
				Result := l_representation.to_string (value (a_object))
			else
				Result := to_string_directly (a_object)
			end
		end

	value (a_object: EL_REFLECTIVE): G
		do
			enclosing_object := a_object
			Result := field_value (index)
		end

feature -- Status query

	has_representation: BOOLEAN
		-- `True' if associated with text representation object
		do
			Result := attached representation
		end

	is_expanded: BOOLEAN
		do
			Result := True
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			Result := value (a_current) = value (other)
		end

feature -- Element change

	set_representation (a_representation: like representation)
		require
			correct_type: a_representation.expanded_type ~ {G}
		do
			representation := a_representation
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached representation as l_representation then
				l_representation.append_to_string (value (a_object), str)
			else
				append_directly (a_object, str)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_DATA_REPRESENTATION [G, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			else
				set_directly (a_object, string)
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			if attached representation as l_representation then
				l_representation.write_crc (crc)
			end
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: G)
		deferred
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		deferred
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		deferred
		end

	to_string_directly (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	field_value (i: INTEGER): G
		deferred
		end

end