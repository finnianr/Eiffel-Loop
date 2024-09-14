note
	description: "Set of objects conforming to ${EL_SET_MEMBER [HASHABLE]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-14 7:33:02 GMT (Saturday 14th September 2024)"
	revision: "6"

class
	EL_MEMBER_SET [G -> EL_SET_MEMBER [G]]

inherit
	EL_HASH_SET [G]
		redefine
			same_keys
		end

create
	make_equal, make

feature -- Comparison

	same_keys (a_search_key, a_key: G): BOOLEAN
		do
			Result := a_search_key.is_same_as (a_key)
		end

end