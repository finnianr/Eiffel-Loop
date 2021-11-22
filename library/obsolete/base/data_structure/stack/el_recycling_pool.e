note
	description: "Pool of reuseable objects implemented as an [$source ARRAYED_STACK [G]]"
	notes: "[
		**Canonical Usage Pattern**
		
			if attached {EL_POOL_SCOPE} Shared_pool as pool then
				pool.start_scope
				if attached pool.reuse_item as item then
					-- do something with `item'
				then
				pool.recycle (item)
				pool.end_scope
			end
			
		**Abbreviated Usage Pattern**
		
			if attached Shared_pool.new_scope as pool and then attached pool.reuse_item as item then
				-- do something with `item'
				pool.recycle_end (item)
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 14:27:27 GMT (Thursday 12th August 2021)"
	revision: "3"

class
	EL_RECYCLING_POOL [G]

obsolete
	"Use EL_BORROWED_OBJECT_SCOPE or EL_ITERABLE_POOL_SCOPE instead"

inherit
	ARRAYED_STACK [G]
		rename
			make as make_stack
		export
			{NONE} all
		end

	EL_POOL_SCOPE_I [G]
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_new_item: like new_item)
		do
			new_item := a_new_item
			make_stack (5)
			create scope_stack.make (5)
		end

feature -- Access

	new_scope: EL_POOL_SCOPE_I [G]
		do
			start_scope
			Result := Current
		end

feature {NONE} -- Implementation

	end_scope
		do
			scope_stack.remove
		end

	reclaim (list: LIST [G])
		-- reclaim all items from `list'
		do
			list.do_all (agent recycle)
			list.wipe_out
		end

	recycle (a_item: like item)
		do
			put (a_item)
			scope_stack.replace (scope_stack.item - 1)
		end

	recycle_end (a_item: like item)
		-- recycle item and end the current scope
		do
			recycle (a_item)
			end_scope
		end

	recycled_all: BOOLEAN
		-- `True' if all items within current scope have been recycled
		do
			Result := scope_stack.item = 0
		end

	reuse_item: like item
		-- item for reuse within currently defined scope
		do
			if is_empty then
				new_item.apply
				Result := new_item.last_result
			else
				Result := item
				remove
			end
			scope_stack.replace (scope_stack.item + 1)
		end

	start_scope
		do
			scope_stack.put (0)
		end

feature {NONE} -- Internal attributes

	new_item: FUNCTION [G]

	scope_stack: ARRAYED_STACK [INTEGER]

end
