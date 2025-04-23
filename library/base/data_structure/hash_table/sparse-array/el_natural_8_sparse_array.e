note
	description: "Sparse array table with ${NATURAL_8} keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 10:41:22 GMT (Wednesday 23rd April 2025)"
	revision: "1"

class
	EL_NATURAL_8_SPARSE_ARRAY [G]

inherit
	EL_SPARSE_ARRAY_TABLE [G, NATURAL_8]

create
	make

feature {NONE} -- Implementation

	as_integer (key: NATURAL_8): INTEGER
		do
			Result := key.to_integer_32
		end

	index_to_key (index: INTEGER): NATURAL_8
		do
			Result := index.to_natural_8
		end

end