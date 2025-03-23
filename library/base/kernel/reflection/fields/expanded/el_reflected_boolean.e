note
	description: "Reflected ${BOOLEAN} field"
	notes: "[
		Routine `set_from_string' can set a ${BOOLEAN} field using any of the string values:
		
			"True" or "1" or "False" or "0"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-23 7:57:50 GMT (Sunday 23rd March 2025)"
	revision: "26"

class
	EL_REFLECTED_BOOLEAN

inherit
	EL_REFLECTED_EXPANDED_FIELD [BOOLEAN]
		rename
			abstract_type as Boolean_type
		end

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.boolean_bytes
		end

	value (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := {ISE_RUNTIME}.boolean_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0
			)
		end

feature -- Conversion

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			if value (a_object) then
				Result := 1
			end
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: BOOLEAN)
		do
			{ISE_RUNTIME}.set_boolean_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0, a_value
			)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_boolean)
		end

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			set (a_object, a_value.to_boolean)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_boolean)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if representation = Void then
				set_directly (a_object, string)

			elseif attached {EL_STRING_FIELD_REPRESENTATION [BOOLEAN, ANY]} representation as r then
				set (a_object, r.to_value (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_boolean (value (a_object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: BOOLEAN)
		do
			string.append_boolean (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_boolean (v)
			end
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.count = 1 and then string.is_natural then
				set (a_object, string.to_natural.to_boolean)
			else
				set (a_object, string.to_boolean)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING
		do
			if value (a_object) then
				Result := True_string
			else
				Result := False_string
			end
		end

feature {NONE} -- Constants

	False_string: STRING = "False"

	True_string: STRING = "True"

end