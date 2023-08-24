note
	description: "Pool of reuseable objects that are either created or lent to client"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_FACTORY_POOL [G]

inherit
	ARRAYED_STACK [G]
		rename
			put as recycle
		export
			{NONE} all
			{ANY} recycle
		end

feature -- Access

	borrowed_item: G
		do
			if is_empty then
				Result := new_item
			else
				Result := item
				remove
			end
		end

feature {NONE} -- Implementation

	new_item: G
		deferred
		end
end