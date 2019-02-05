note
	description: "Integer input field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-05 19:51:21 GMT (Tuesday 5th February 2019)"
	revision: "1"

class
	EL_INTEGER_INPUT_FIELD

inherit
	EL_INPUT_FIELD [INTEGER]

create
	make

feature {NONE} -- Implementation

	to_data (str: STRING_32): INTEGER
		do
			force_numeric_text
			if not text.is_empty then
				Result := text.to_integer
			end
		end

	to_text (a_value: INTEGER): STRING
		do
			Result := a_value.out
		end

end
