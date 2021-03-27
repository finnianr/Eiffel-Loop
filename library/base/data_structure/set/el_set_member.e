note
	description: "Object that is a member of a set of type [$source EL_MEMBER_SET [EL_SET_MEMBER]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-25 11:57:45 GMT (Thursday 25th March 2021)"
	revision: "1"

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