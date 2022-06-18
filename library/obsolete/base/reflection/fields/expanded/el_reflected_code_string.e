note
	description: "Reflected access to field of type [$source EL_CODE_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-17 12:56:16 GMT (Sunday 17th October 2021)"
	revision: "1"

class
	EL_REFLECTED_CODE_STRING

inherit
	EL_REFLECTED_EXPANDED_FIELD [EL_CODE_STRING]
		redefine
			make, value
		end

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: like enclosing_object; a_index: INTEGER; a_name: STRING)
		do
			Precursor (a_object, a_index, a_name)
			physical_offset := field_offset (a_index)
		end

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): EL_CODE_STRING_REF
		do
			Result := value (a_object).to_reference
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Natural_64_bytes + 24 -- 24 is header size
		end

	value (a_object: EL_REFLECTIVE): EL_CODE_STRING
		do
			enclosing_object := a_object
			Result.set_area ({ISE_RUNTIME}.natural_16_field (Area_index, object_address, 0))
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: EL_CODE_STRING)
		do
			enclosing_object := a_object
			{ISE_RUNTIME}.set_natural_64_field (Area_index, object_address, 0, a_value.area)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if attached {EL_STRING_REPRESENTATION [EL_CODE_STRING, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			else
				set_directly (a_object, string)
			end
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		local
			code: EL_CODE_STRING
		do
			code.set_area (a_value.to_natural_64)
			set (a_object, code)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		local
			code: EL_CODE_STRING
		do
			code.set_area (readable.read_natural_64)
			set (a_object, code)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_64 (value (a_object).area)
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: EL_CODE_STRING)
		do
			if attached Buffer_8.empty as str then
				a_value.fill (str)
				string.append (str)
			end
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			append (str, value (a_object))
		end

	field_value (i: INTEGER): EL_CODE_STRING
		do
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			code: EL_CODE_STRING
		do
			if string.is_empty then
				set (a_object, code)

			elseif attached Buffer_8.copied_general (string) as str_8 then
				code.set (str_8)
				set (a_object, code)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING_32
		do
			if attached Buffer_32.empty as str then
				append (str, value (a_object))
				Result := str.twin
			end
		end

feature {NONE} -- Constants

	Area_index: INTEGER = 1
end