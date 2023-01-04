note
	description: "Reflected [$source REAL_64] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "19"

class
	EL_REFLECTED_REAL_64

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_64]
		rename
			field_value as real_64_field
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): REAL_64_REF
		do
			Result := value (a_object).to_reference
		end

feature -- Access

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Real_64_bytes
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_64)
		do
			enclosing_object := a_object
			set_real_64_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_real_64)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_real_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: REAL_64)
		do
			string.append_double (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_real_64 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): REAL_64
		do
			Result := string.to_real_64
		end

end