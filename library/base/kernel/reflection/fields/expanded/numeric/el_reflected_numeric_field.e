note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-24 11:24:21 GMT (Monday 24th March 2025)"
	revision: "35"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]
		redefine
			is_numeric_type, post_make, set_from_string
		end

	EL_MODULE_CONVERT_STRING

feature {NONE} -- Initialization

	post_make
		-- initialization after types have been set
		do
			if Convert_string.has_type (type_id)
				and then attached {like convertor} Convert_string.found_item as item
			then
				convertor := item
			end
		end

feature -- Status query

	Is_numeric_type: BOOLEAN = True

	is_zero (a_object: EL_REFLECTIVE): BOOLEAN
		local
			l_zero: N
		do
			Result := value (a_object) = l_zero
		end

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		-- This redefinition is a workaround for a segmentation fault in finalized exe
			if representation = Void then
				set_directly (a_object, string)

			elseif attached {EL_STRING_FIELD_REPRESENTATION [N, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			end
		end

feature {NONE} -- Implementation

	set (a_object: EL_REFLECTIVE; a_value: N)
		-- `a_value: like value' causes a segmentation fault in `{EL_REFLECTED_ENUMERATION}.set_from_string'
		deferred
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_immutable then
			-- workaround for bug in {STRING_TO_INTEGER_CONVERTOR}.parse_string_with_type
				set (a_object, convertor.as_type (string)) -- benchmark passes: 503.0 times (-55.4%)
			else
				set (a_object, to_value (string)) -- benchmark passes: 1128.0 times (100%)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING
		local
			n, v: like value
		do
			v := value (a_object)
			if v = n.zero then
				Result := Zero
			elseif v = n.one then
				Result := One
			elseif attached Buffer_8.empty as str then
				append_value (str, v)
				Result := str.twin
			end
		end

	to_value (string: READABLE_STRING_GENERAL): N
		deferred
		end

feature {NONE} -- Internal attributes

	convertor: EL_READABLE_STRING_GENERAL_TO_TYPE [N]

feature {NONE} -- Constants

	One: STRING = "1"

	Zero: STRING = "0"

end