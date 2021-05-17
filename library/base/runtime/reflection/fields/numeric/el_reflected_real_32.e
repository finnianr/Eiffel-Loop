note
	description: "Reflected [$source REAL_32] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 13:43:02 GMT (Monday 17th May 2021)"
	revision: "12"

class
	EL_REFLECTED_REAL_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_32]
		rename
			field_value as real_32_field
		end

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end


feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_32)
		do
			enclosing_object := a_object
			set_real_32_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	string_value (string: READABLE_STRING_GENERAL): REAL_32
		do
			Result := string.to_real_32
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_real_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_real_32 (value (a_object))
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: REAL_32)
		do
			crc.add_real_32 (enum_value)
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: REAL_32)
		do
			string.append_real (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_real_32 (v)
			end
		end

end