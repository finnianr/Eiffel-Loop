note
	description: "Field that conforms to type [$source EL_REFLECTED_REFERENCE] `[EL_MAKEABLE_FROM_STRING_GENERAL]'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 10:42:42 GMT (Tuesday 11th June 2019)"
	revision: "8"

deferred class
	EL_REFLECTED_MAKEABLE_FROM_STRING [MAKEABLE -> EL_MAKEABLE_FROM_STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [MAKEABLE]
		undefine
			set_from_readable, write
		redefine
			default_defined, initialize_default, reset,
			set_from_string, set_from_readable, to_string
		end

	EL_REFLECTOR_CONSTANTS

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			value (a_object).make_from_general (string)
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).to_string
		end

feature -- Status query

	default_defined: BOOLEAN
		do
			if not Default_value_table.has (type_id)
				and then field_conforms_to (type_id, makeable_from_string_type_id)
			then
				Result := True
			end
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as l_value then
				l_value.make_default
			end
		end

feature {NONE} -- Implementation

	initialize_default
		do
			if attached {like default_value} new_default_value as new_value then
				new_value.make_default
				default_value := new_value
			end
		end

	makeable_from_string_type_id: INTEGER
		deferred
		end

end