note
	description: "Reflected ${CHARACTER_32} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-23 8:03:43 GMT (Sunday 23rd March 2025)"
	revision: "27"

class
	EL_REFLECTED_CHARACTER_32

inherit
	EL_REFLECTED_EXPANDED_FIELD [CHARACTER_32]
		rename
			abstract_type as Character_32_type
		end

create
	make

feature -- Access

	value (a_object: EL_REFLECTIVE): CHARACTER_32
		do
			Result := {ISE_RUNTIME}.character_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0
			)
		end

feature -- Measurement

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Character_32_bytes
		end

feature -- Conversion

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			Result := value (a_object).natural_32_code.to_natural_64
		end

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: CHARACTER_32)
		do
			{ISE_RUNTIME}.set_character_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0, a_value
			)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_character_32)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_character_32)
		end

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			set (a_object, a_value.to_character_32)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if representation = Void then
				set_directly (a_object, string)

			elseif attached {EL_STRING_FIELD_REPRESENTATION [CHARACTER_32, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_character_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING_GENERAL; a_value: CHARACTER_32)
		do
			string.append_code (a_value.natural_32_code)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_character (v)
			end
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_empty then
				set (a_object, '%U')
			else
				set (a_object, string.item (1).to_character_32)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING_32
		do
			create Result.make_filled (value (a_object), 1)
		end

end