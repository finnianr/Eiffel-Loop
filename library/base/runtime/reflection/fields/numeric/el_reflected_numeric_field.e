note
	description: "Field conforming to `NUMERIC'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 15:08:17 GMT (Monday 30th November 2020)"
	revision: "11"

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
			if attached enumeration as enum then
				Result := enumeration.name (v)

			elseif v = n.zero then
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

	is_enumeration: BOOLEAN
		-- `True' if field is associated with an enumeration
		do
			Result := attached enumeration
		end

feature -- Element change

	set_enumeration (a_enumeration: EL_ENUMERATION [N])
		do
			enumeration := a_enumeration
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: like value)
		deferred
		end

	enumeration_value (a_enumeration: EL_ENUMERATION [N]; string: READABLE_STRING_GENERAL): like value
		do
			if attached {STRING} string as str_8 then
				Result := a_enumeration.value (str_8)
			else
				Result := a_enumeration.value (once_general_copy_8 (string))
			end
		end

feature {NONE} -- Internal attributes

	enumeration: detachable EL_ENUMERATION [N]

feature {NONE} -- Constants

	One: STRING = "1"

	Zero: STRING = "0"

end