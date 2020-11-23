note
	description: "Stack pool of reuseable objects"
	notes: "[
		Call `reuseable_item' for either new or recycled object.
		Return to pool when finished with `recycle'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 14:04:18 GMT (Monday 23rd November 2020)"
	revision: "2"

class
	EL_RECYCLING_POOL [G]

inherit
	ARRAYED_STACK [G]
		rename
			make as make_stack
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_new_item: like new_item)
		do
			new_item := a_new_item
			make_stack (5)
		end

feature -- Access

	reuseable_item: like item
		-- a new or recycled object
		do
			if is_empty then
				new_item.apply
				Result := new_item.last_result
			else
				Result := item
				remove
			end
		end

feature -- Element change

	recycle (a_item: like item)
		do
			put (a_item)
		end

feature {NONE} -- Internal attributes

	new_item: FUNCTION [G]

end