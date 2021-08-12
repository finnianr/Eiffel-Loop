note
	description: "Abstract interface for [$source EL_RECYCLING_POOL [G]]. See routine ''new_scope''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 14:23:40 GMT (Thursday 12th August 2021)"
	revision: "1"

deferred class
	EL_POOL_SCOPE [G]

feature -- Access

	reuse_item: like item
		-- item for reuse within currently defined scope
		deferred
		end

feature -- Status query

	recycled_all: BOOLEAN
		-- `True' if all items within current scope have been recycled
		deferred
		end

feature -- Status change

	end_scope
		require
			recycled_all: recycled_all
		deferred
		end

	start_scope
		deferred
		end

feature -- Element change

	reclaim (list: LIST [G])
		-- reclaim all items from `list'
		deferred
		end

	recycle (a_item: like item)
		deferred
		end

	recycle_end (a_item: like item)
		-- recycle item and end the current scope
		deferred
		end

feature {NONE} -- Implementation

	item: G
		deferred
		end
end