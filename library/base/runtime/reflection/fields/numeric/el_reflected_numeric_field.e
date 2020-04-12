note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 16:04:54 GMT (Sunday 12th April 2020)"
	revision: "8"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]

	EL_SHARED_ONCE_STRING_8

feature -- Access

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING
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

feature -- Status query

	is_zero (a_object: EL_REFLECTIVELY_SETTABLE): BOOLEAN
		local
			l_zero: N
		do
			Result := value (a_object) = l_zero
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: like value)
		deferred
		end

feature {NONE} -- Constants

	One: STRING = "1"
	Zero: STRING = "0"

end
