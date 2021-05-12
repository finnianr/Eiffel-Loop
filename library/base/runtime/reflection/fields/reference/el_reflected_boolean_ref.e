note
	description: "Field conforming to [$source BOOLEAN_REF]"
	tests: "Class [$source PP_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-12 9:27:38 GMT (Wednesday 12th May 2021)"
	revision: "12"

class
	EL_REFLECTED_BOOLEAN_REF

inherit
	EL_REFLECTED_REFERENCE [BOOLEAN_REF]
		redefine
			append_to_string, set_from_integer, set_from_readable, set_from_string,  write
		end

create
	make

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_boolean (v.item)
			end
		end

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
			if attached value (a_object) as v and then string.is_boolean then
				v.set_item (string.to_boolean)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_boolean (value (a_object).item)
		end

end