note
	description: "Reflected field conforming to ${BOOLEAN_REF}"
	tests: "Class ${PAYPAL_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:12 GMT (Monday 28th April 2025)"
	revision: "19"

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

	append_to_string (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_boolean (v.item)
			end
		end

	reset (object: ANY)
		do
			if attached value (object) as v then
				v.set_item (False)
			end
		end

	set_from_integer (object: ANY; a_value: INTEGER_32)
			-- Internal attributes
		do
			value (object).set_item (a_value.to_boolean)
		end

	set_from_readable (object: ANY; a_value: EL_READABLE)
		do
			value (object).set_item (a_value.read_boolean)
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached value (object) as v and then string.is_boolean then
				v.set_item (string.to_boolean)
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_boolean (value (object).item)
		end

end