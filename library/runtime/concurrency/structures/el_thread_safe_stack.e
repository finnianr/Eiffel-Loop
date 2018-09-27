note
	description: "Thread safe stack"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_THREAD_SAFE_STACK [G]

inherit
	ARRAYED_STACK [G]
		rename
			item as stack_item,
			is_empty as is_stack_empty,
			put as stack_put,
			wipe_out as stack_wipe_out,
			remove as stack_remove,
			count as stack_count
		export
			{NONE} all
		redefine
			make
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			-- Create linked stack.
		do
			make_default
			Precursor (n)
		end

feature -- Removal

	removed_item: G
			-- Atomic action to ensure removed item belongs to same thread as the item
			-- CQS isn't everything you know.
		do
			restrict_access
			Result := stack_item
			stack_remove

			end_restriction
		end

feature -- Access

	count: INTEGER
			--
		do
			restrict_access
			Result := stack_count
			end_restriction
		end

feature -- Status report

	is_empty: BOOLEAN
			--
		do
			restrict_access
				Result := is_stack_empty
			end_restriction
		end

feature -- Element change

	put (v: G)
			--
		do
			restrict_access
				stack_put (v)
			end_restriction
		end

	wipe_out
			--
		do
			restrict_access
				stack_wipe_out
			end_restriction
		end

end