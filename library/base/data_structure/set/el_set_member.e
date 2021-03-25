note
	description: "Object that is a member of a set of type [$source EL_MEMBER_SET [EL_SET_MEMBER]]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
