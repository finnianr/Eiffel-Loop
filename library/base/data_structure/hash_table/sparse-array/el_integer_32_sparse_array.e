note
	description: "Sparse array table with ${INTEGER_32} keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 15:16:54 GMT (Wednesday 23rd April 2025)"
	revision: "1"

class
	EL_INTEGER_32_SPARSE_ARRAY [G]

inherit
	EL_SPARSE_ARRAY_TABLE [G, INTEGER_32]

create
	make

feature {NONE} -- Implementation

	as_integer (key: INTEGER_32): INTEGER
		do
			Result := key
		end

	index_to_key (index: INTEGER): INTEGER_32
		do
			Result := index
		end

end