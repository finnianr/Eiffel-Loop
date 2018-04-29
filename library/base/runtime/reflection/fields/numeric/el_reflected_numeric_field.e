note
	description: "Summary description for {EL_REFLECTED_NUMERIC_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 8:53:20 GMT (Thursday 26th April 2018)"
	revision: "5"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]

feature -- Access

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING
		local
			n: N; v: like value
			str: STRING
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

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		local
			n: N
		do
			set (a_object, n.zero)
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: like value)
		deferred
		end

feature {NONE} -- Constants

	Zero: STRING = "0"

	One: STRING = "1"
end
