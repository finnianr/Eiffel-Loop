note
	description: "Common expanded fields including `BOOLEAN', `POINTER' and fields conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 12:19:25 GMT (Monday 17th May 2021)"
	revision: "11"

deferred class
	EL_REFLECTED_EXPANDED_FIELD [G]

inherit
	EL_REFLECTED_FIELD

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set_from_integer (a_object, 0)
		end

feature -- Access

	representation: ANY
		-- object allowing text representation and conversion of field

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached representation as any_ref then
				Result := to_string_indirectly (a_object, any_ref)
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

	set_representation (a_representation: ANY)
		do
			representation := a_representation
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached representation as any_ref then
				append_indirectly (a_object, str, any_ref)
			else
				append_directly (a_object, str)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached representation as any_ref then
				set_indirectly (a_object, string, any_ref)
			else
				set_directly (a_object, string)
			end
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: G)
		deferred
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		deferred
		end

	append_indirectly (a_object: EL_REFLECTIVE; str: ZSTRING; any_ref: ANY)
		deferred
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		deferred
		end

	set_indirectly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL; a_representation: ANY)
		deferred
		end

	to_string_directly (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	to_string_indirectly (a_object: EL_REFLECTIVE; a_representation: ANY): READABLE_STRING_GENERAL
		deferred
		end

	field_value (i: INTEGER): G
		deferred
		end

end