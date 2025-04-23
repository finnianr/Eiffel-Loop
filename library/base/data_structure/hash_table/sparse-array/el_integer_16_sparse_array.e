note
	description: "Sparse array table with ${INTEGER_16} keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 10:42:33 GMT (Wednesday 23rd April 2025)"
	revision: "1"

class
	EL_INTEGER_16_SPARSE_ARRAY [G]

inherit
	EL_SPARSE_ARRAY_TABLE [G, INTEGER_16]

create
	make

feature {NONE} -- Implementation

	as_integer (key: INTEGER_16): INTEGER
		do
			Result := key.to_integer_32
		end

	index_to_key (index: INTEGER): INTEGER_16
		do
			Result := index.to_integer_16
		end

end