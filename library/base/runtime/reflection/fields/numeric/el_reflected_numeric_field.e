note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-12 17:41:21 GMT (Saturday 12th December 2020)"
	revision: "14"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]

	EL_SHARED_ONCE_STRING_8

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING
		local
			n, v: like field_value; str: STRING
		do
			v := value (a_object)
			if v = n.zero then
				Result := Zero
			elseif v = n.one then
				Result := One
			else
				str := empty_once_string_8
				append (str, v)
				Result := str.twin
			end
		end

feature -- Conversion

	to_enumeration (a_enumeration: EL_ENUMERATION [N]): EL_REFLECTED_ENUMERATION [N]
		deferred
		end

feature -- Status query

	is_zero (a_object: EL_REFLECTIVE): BOOLEAN
		local
			l_zero: N
		do
			Result := value (a_object) = l_zero
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: N)
		deferred
		end

	set (a_object: EL_REFLECTIVE; a_value: N)
		-- `a_value: like value' causes a segmentation fault in `{EL_REFLECTED_ENUMERATION}.set_from_string'
		deferred
		end

feature {NONE} -- Constants

	One: STRING = "1"

	Zero: STRING = "0"

end