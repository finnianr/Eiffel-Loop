note
	description: "Reflected ${POINTER} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:18:52 GMT (Monday 28th April 2025)"
	revision: "25"

class
	EL_REFLECTED_POINTER

inherit
	EL_REFLECTED_EXPANDED_FIELD [POINTER]
		rename
			abstract_type as Pointer_type
		end

create
	make

feature -- Access

	reference_value (object: ANY): like value.to_reference
		do
			create Result
			Result.set_item (value (object))
		end

	size_of (object: ANY): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.pointer_bytes
		end

feature -- Conversion

	to_natural_64 (object: ANY): NATURAL_64
		do
			if attached Pointer_buffer as buffer then
				buffer.put_pointer (value (object), 0)
				if buffer.count = 4 then
					Result := buffer.read_natural_32 (0).to_natural_64
				else
					Result := buffer.read_natural_64 (0)
				end
			end
		end

	value (object: ANY): POINTER
		do
			Result := {ISE_RUNTIME}.pointer_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

feature -- Basic operations

	set (object: ANY; a_value: POINTER)
		do
			{ISE_RUNTIME}.set_pointer_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, a_value
			)
		end

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		do
			if attached Pointer_buffer as buffer then
				if buffer.count = 4 then
					buffer.put_natural_32 (a_value.to_natural_32, 0)
				else
					buffer.put_natural_64 (a_value, 0)
				end
				set (object, buffer.read_pointer (0))
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_pointer)
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
		-- This redefinition is a workaround for a segmentation fault in finalized exe
			if representation = Void then
				set_directly (object, string)

			elseif attached {EL_STRING_FIELD_REPRESENTATION [POINTER, ANY]} representation as l_representation then
				set (object, l_representation.to_value (string))
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_pointer (value (object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: POINTER)
		do
			string.append (a_value.out)
		end

	append_directly (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_string_general (v.out)
			end
		end

	set_directly (object: ANY; string: READABLE_STRING_GENERAL)
		do
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		do
			if a_value = 0 then
				set (object, default_pointer)
			end
		end

	to_string_directly (object: ANY): STRING
		do
			Result := value (object).out
		end

feature {NONE} -- Constants

	Pointer_buffer: MANAGED_POINTER
		once
			create Result.make ({PLATFORM}.pointer_bytes)
		end
end