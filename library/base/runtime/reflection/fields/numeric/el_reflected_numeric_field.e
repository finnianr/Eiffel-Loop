note
	description: "Summary description for {EL_REFLECTED_NUMERIC_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 18:27:50 GMT (Wednesday 17th January 2018)"
	revision: "3"

deferred class
	EL_REFLECTED_NUMERIC_FIELD [N -> NUMERIC]

inherit
	EL_REFLECTED_EXPANDED_FIELD [N]

feature -- Access

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING
		local
			n: N; l_value: like value
			str: STRING
		do
			l_value := value (a_object)
			if l_value = n.zero then
				Result := Zero
			elseif l_value = n.one then
				Result := One
			else
				str := empty_once_string_8
				append (str, l_value)
				Result := str.twin
			end
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: like value)
		deferred
		end

feature {NONE} -- Constants

	Zero: STRING = "0"

	One: STRING = "0"
end
