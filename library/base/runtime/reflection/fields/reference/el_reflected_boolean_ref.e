note
	description: "Field conforming to [$source BOOLEAN_REF]"
	tests: "[$source PP_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 17:23:43 GMT (Wednesday   2nd   October   2019)"
	revision: "8"

class
	EL_REFLECTED_BOOLEAN_REF

inherit
	EL_REFLECTED_REFERENCE [BOOLEAN_REF]
		redefine
			set_from_integer, set_from_readable, set_from_string,  write
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
		local
			l_value: BOOLEAN_REF
		do
			l_value := value (a_object)
			if attached {EL_REFLECTIVE_BOOLEAN_REF} l_value as reflective_value then
				reflective_value.set_from_string (string)
			elseif string.is_boolean then
				l_value.set_item (string.to_boolean)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_boolean (value (a_object).item)
		end

end
