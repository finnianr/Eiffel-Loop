note
	description: "Field conforming to [$source EL_BOOLEAN_REF]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-17 7:34:26 GMT (Wednesday 17th July 2019)"
	revision: "5"

class
	EL_REFLECTED_BOOLEAN_REF

inherit
	EL_REFLECTED_REFERENCE [BOOLEAN_REF]
		redefine
			Default_objects, set_from_integer, set_from_readable, set_from_string,  write
		end

create
	make

feature -- Basic operations

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
			-- Internal attributes
		do
			value (a_object).set_item (a_value.to_boolean)
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			value (a_object).set_item (a_value.read_boolean)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_boolean then
				value (a_object).set_item (string.to_boolean)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_boolean (value (a_object).item)
		end

feature {NONE} -- Constants

	Default_objects: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<<
				create {BOOLEAN_REF}, create {EL_BOOLEAN_REF}.make_default, create {EL_BOOLEAN_OPTION}
			>>)
		end

end
