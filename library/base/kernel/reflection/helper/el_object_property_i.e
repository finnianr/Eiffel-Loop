note
	description: "Access properties of object via class ${REFLECTED_REFERENCE_OBJECT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 9:36:14 GMT (Saturday 5th April 2025)"
	revision: "1"

deferred class
	EL_OBJECT_PROPERTY_I

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	property (object: ANY): REFLECTED_REFERENCE_OBJECT
		do
			Result := Reflected_reference_object
			Result.set_object (object)
		end

feature {NONE} -- Constants

	Object_overhead: INTEGER = 32
		-- memory overhead for any object excluding all attributes

	Reflected_reference_object: REFLECTED_REFERENCE_OBJECT
		-- Abstraction to reflect on objects.
		once
			create Result.make (Current)
		end

end