note
	description: "Reflected pointer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:52:10 GMT (Monday 3rd May 2021)"
	revision: "10"

class
	EL_REFLECTED_POINTER

inherit
	EL_REFLECTED_EXPANDED_FIELD [POINTER]
		rename
			field_value as pointer_field
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING
		do
			Result := value (a_object).out
		end

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (v.out)
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: POINTER)
		do
			enclosing_object := a_object
			set_pointer_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_pointer)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_pointer (value (a_object))
		end

feature {NONE} -- Unimplemented

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			if a_value = 0 then
				set (a_object, default_pointer)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		end

end