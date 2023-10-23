note
	description: "Reflected [$source POINTER] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-23 14:24:14 GMT (Monday 23rd October 2023)"
	revision: "20"

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

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.pointer_bytes
		end

feature -- Conversion

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			if attached Pointer_buffer as buffer then
				buffer.put_pointer (value (a_object), 0)
				if buffer.count = 4 then
					Result := buffer.read_natural_32 (0).to_natural_64
				else
					Result := buffer.read_natural_64 (0)
				end
			end
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: POINTER)
		do
			enclosing_object := a_object
			set_pointer_field (index, a_value)
		end

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			if attached Pointer_buffer as buffer then
				if buffer.count = 4 then
					buffer.put_natural_32 (a_value.to_natural_32, 0)
				else
					buffer.put_natural_64 (a_value, 0)
				end
				set (a_object, buffer.read_pointer (0))
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_pointer)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if attached {EL_STRING_FIELD_REPRESENTATION [POINTER, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			else
				set_directly (a_object, string)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_pointer (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: POINTER)
		do
			string.append (a_value.out)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (v.out)
			end
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			if a_value = 0 then
				set (a_object, default_pointer)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING
		do
			Result := value (a_object).out
		end

feature {NONE} -- Constants

	Pointer_buffer: MANAGED_POINTER
		once
			create Result.make ({PLATFORM}.pointer_bytes)
		end
end