note
	description: "Reflected field for type conforming to [$source EL_ALPHA_NUMERIC_CODE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 13:48:03 GMT (Saturday 16th October 2021)"
	revision: "1"

deferred class
	EL_REFLECTED_ALPHA_NUMERIC_CODE [G -> EL_ALPHA_NUMERIC_CODE]

inherit
	EL_REFLECTED_EXPANDED_FIELD [EL_ALPHA_NUMERIC_CODE]
		redefine
			make
		end

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: like enclosing_object; a_index: INTEGER; a_name: STRING)
		do
			Precursor (a_object, a_index, a_name)
			physical_offset := field_offset (a_index)
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: G)
		deferred
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if attached {EL_STRING_REPRESENTATION [G, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			else
				set_directly (a_object, string)
			end
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: EL_ALPHA_NUMERIC_CODE)
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

	field_value (i: INTEGER): G
		do
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING_32
		do
			if attached Buffer_32.empty as str then
				append (str, value (a_object))
				Result := str.twin
			end
		end

end