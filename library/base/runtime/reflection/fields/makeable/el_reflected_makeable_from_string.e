note
	description: "Summary description for {EL_REFLECTED_MAKEABLE_FROM_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 17:48:42 GMT (Wednesday 17th January 2018)"
	revision: "4"

deferred class
	EL_REFLECTED_MAKEABLE_FROM_STRING

inherit
	EL_REFLECTED_REFERENCE
		redefine
			default_value, default_defined, initialize_default, reset,
			set_from_string, set_from_readable, to_string
		end

	EL_REFLECTOR_CONSTANTS

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, as_string (readable))
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			enclosing_object := a_object
			if attached {like default_value} reference_field (index) as l_value then
				l_value.make_from_general (string)
			end
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).to_string
		end

feature -- Status query

	default_defined: BOOLEAN
		do
			Result := not Default_value_table.has (type_id)
									and then field_conforms_to (type_id, Makeable_from_string_type)
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as l_value then
				l_value.make_default
			end
		end

feature {NONE} -- Implementation

	as_string (readable: EL_READABLE): STRING_GENERAL
		deferred
		end

	initialize_default
		do
			if attached {like default_value} new_default_value as new_value then
				new_value.make_default
				default_value := new_value
			end
		end

feature {NONE} -- Internal attributes

	default_value: detachable EL_MAKEABLE_FROM_STRING

end
