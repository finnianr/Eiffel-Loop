note
	description: "Reflected field conforming to ${BOOLEAN_REF}"
	tests: "Class ${PAYPAL_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 9:04:58 GMT (Monday 26th August 2024)"
	revision: "18"

class
	EL_REFLECTED_BOOLEAN_REF

inherit
	EL_REFLECTED_REFERENCE [BOOLEAN_REF]
		redefine
			append_to_string, reset, set_from_integer, set_from_readable, set_from_string, write
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

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as v then
				v.set_item (False)
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

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_boolean (value (a_object).item)
		end

end