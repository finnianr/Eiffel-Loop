note
	description: "[
		Hash table conforming to HASH_TABLE [ANY, NATURAL_64] where the key is a digest of
		an array of 32-BIT integers: `SPECIAL [INTEGER_32]'. Used in ${EL_INITIALIZED_OBJECT_FACTORY}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-04 9:15:30 GMT (Wednesday 4th September 2024)"
	revision: "1"

class
	EL_INTEGER_ARRAY_KEY_TABLE [G]

inherit
	HASH_TABLE [G, NATURAL_64]

create
	make, make_equal

feature -- Access

	last_key: NATURAL_64

feature -- Status query

	has_hashed_key (n: INTEGER_32; n_array: SPECIAL [INTEGER_32]): BOOLEAN
		-- Is there an item in the table with created from hashed values of `n' and `n_array'?
		-- Set `found_item' to the found item.
		local
			key: NATURAL_64; i: INTEGER
		do
			key := n.to_natural_64 * Big_prime
			from i := 0 until i = n_array.count loop
				key := key.bit_xor (n_array [i].to_natural_64) * Big_prime
				i := i + 1
			end
			last_key := key
			Result := has_key (key)
		end

feature {NONE} -- Constants

	Big_prime: NATURAL_64 = 11400714819323198485
end