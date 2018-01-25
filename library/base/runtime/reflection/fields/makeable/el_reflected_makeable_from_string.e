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
			default_value, set_from_string, set_from_readable, to_string
		end

	EL_REFLECTOR_CONSTANTS

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, as_string (readable))
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			new_value: like default_value
		do
			if attached {like default_value} default_value as l_value then
				new_value := l_value.twin
				new_value.make_from_general (string)
				set (a_object, new_value)
			end
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).to_string
		end

feature {NONE} -- Implementation

	as_string (readable: EL_READABLE): STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	default_value: detachable EL_MAKEABLE_FROM_STRING

end
