note
	description: "Object that is a member of a set of type ${EL_MEMBER_SET [EL_SET_MEMBER]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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