note
	description: "Table of computed values for ${INTEGER_16} numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 16:55:22 GMT (Tuesday 22nd April 2025)"
	revision: "1"

class
	COMPUTED_INTEGER_64_TABLE

inherit
	EL_SPARSE_ARRAY_TABLE [INTEGER_64, INTEGER_16]

create
	make

feature {NONE} -- Implementation

	as_integer (a_key: INTEGER_16): INTEGER
		do
			Result := a_key.to_integer_32
		end

end