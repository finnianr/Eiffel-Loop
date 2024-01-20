note
	description: "Object that is a member of a set of type ${EL_MEMBER_SET [EL_SET_MEMBER]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SET_MEMBER [G -> HASHABLE]

inherit
	HASHABLE

feature -- Comparison

	is_same_as (other: G): BOOLEAN
		-- `True' if `Current' is equivalent to `other'
		deferred
		end

end