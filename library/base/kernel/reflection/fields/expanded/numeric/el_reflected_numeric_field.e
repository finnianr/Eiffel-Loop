note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 21:58:12 GMT (Saturday 18th November 2023)"
	revision: "30"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]
		redefine
			set_from_string
		end

feature -- Status query

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
			if attached {EL_STRING_FIELD_REPRESENTATION [N, ANY]} representation as l_representation then
				set (a_object, l_representation.to_value (string))
			else
				set_directly (a_object, string)
			end
		end

feature {NONE} -- Implementation

	set (a_object: EL_REFLECTIVE; a_value: N)
		-- `a_value: like value' causes a segmentation fault in `{EL_REFLECTED_ENUMERATION}.set_from_string'
		deferred
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, to_value (string))
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

feature {NONE} -- Constants

	One: STRING = "1"

	Zero: STRING = "0"

end