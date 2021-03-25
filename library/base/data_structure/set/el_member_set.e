note
	description: "Set of objects conforming to [$source EL_SET_MEMBER [HASHABLE]]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MEMBER_SET [G -> EL_SET_MEMBER [G]]

inherit
	EL_HASH_SET [G]
		rename
			make_equal as make,
			make as make_set
		redefine
			same_keys
		end

create
	make

feature -- Comparison

	same_keys (a_search_key, a_key: G): BOOLEAN
		do
			Result := a_search_key.is_same_as (a_key)
		end

end
