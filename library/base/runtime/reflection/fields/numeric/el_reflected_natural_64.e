note
	description: "[
		[$source NATURAL_64] field
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:51:08 GMT (Monday 3rd May 2021)"
	revision: "11"

class
	EL_REFLECTED_NATURAL_64

inherit
	EL_REFLECTED_NUMERIC_FIELD [NATURAL_64]
		rename
			field_value as natural_64_field
		end

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Conversion

	to_enumeration (a_enumeration: EL_ENUMERATION [NATURAL_64]): EL_REFLECTED_ENUM_NATURAL_64
		do
			create Result.make (Current, a_enumeration)
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_natural_64 (v)
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			enclosing_object := a_object
			set_natural_64_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_natural_64)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_natural_64)
		end

	string_value (string: READABLE_STRING_GENERAL): NATURAL_64
		do
			Result := string.to_natural_64
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: NATURAL_64)
		do
			string.append_natural_64 (a_value)
		end

end