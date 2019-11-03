note
	description: "Field that conforms to type [$source EL_REFLECTED_REFERENCE] `[EL_MAKEABLE_FROM_STRING_GENERAL]'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 13:54:50 GMT (Thursday 3rd October 2019)"
	revision: "10"

deferred class
	EL_REFLECTED_MAKEABLE_FROM_STRING [MAKEABLE -> EL_MAKEABLE_FROM_STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [MAKEABLE]
		undefine
			set_from_readable, write
		redefine
			is_initializeable,
			reset, set_from_string, set_from_readable, to_string
		end

	EL_REFLECTOR_CONSTANTS undefine is_equal end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).to_string
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as l_value then
				l_value.make_default
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			value (a_object).make_from_general (string)
		end

feature -- Status query

	is_initializeable: BOOLEAN
		-- `True' when possible to create an initialized instance of the field
		do
			Result := Precursor or else field_conforms_to (type_id, makeable_from_string_type_id)
		end

feature {NONE} -- Implementation

	makeable_from_string_type_id: INTEGER
		deferred
		end

end
