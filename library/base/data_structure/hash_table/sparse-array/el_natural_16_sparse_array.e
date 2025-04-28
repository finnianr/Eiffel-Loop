note
	description: "Sparse array table with ${NATURAL_16} keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 11:43:10 GMT (Monday 28th April 2025)"
	revision: "2"

class
	EL_NATURAL_16_SPARSE_ARRAY [G]

inherit
	EL_SPARSE_ARRAY_TABLE [G, NATURAL_16]

create
	make, make_empty

feature {NONE} -- Implementation

	as_integer (key: NATURAL_16): INTEGER
		do
			Result := key.to_integer_32
		end

	index_to_key (index: INTEGER): NATURAL_16
		do
			Result := index.to_natural_16
		end

end