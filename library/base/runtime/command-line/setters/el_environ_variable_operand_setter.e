note
	description: "Sets a `make' routine argument conforming to type `[$source EL_ENVIRON_VARIABLE]'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 15:28:43 GMT (Wednesday 5th October 2022)"
	revision: "5"

class
	EL_ENVIRON_VARIABLE_OPERAND_SETTER [E -> EL_ENVIRON_VARIABLE create make_from_string end]

inherit
	EL_MAKE_OPERAND_SETTER [E]
		redefine
			is_convertible, value_description, value
		end

feature {NONE} -- Implementation

	is_convertible (str: ZSTRING): BOOLEAN
		do
			Result := str.count >= 3 and then (2 |..| (str.count - 1)).has (str.index_of ('=', 1))
		end

	value (str: ZSTRING): E
		do
			create Result.make_from_string (str)
		end

	value_description: ZSTRING
		do
			Result := Precursor + " assignment"
		end

end